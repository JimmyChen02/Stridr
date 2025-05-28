//
//  RunTracker.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/22/25.
//

import Foundation
import MapKit
import UIKit
import SwiftUICore
import HealthKit

class RunTracker: NSObject, ObservableObject {
    let blueGray = Color(red: 0.4, green: 0.55, blue: 0.7)

    @Published var region = MKCoordinateRegion(center: .init(latitude: 40.7128, longitude: -74.0060), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var isRunning = false
    @Published var presentCountdown = false
    @Published var presentRunView = false
    @Published var presentPauseView = false
    
    private var currentSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    @Published var locations = [CLLocationCoordinate2D]()
    private var timer: Timer?
    private var startTime = Date.now
    
    private var currentLocation: CLLocationCoordinate2D?
    private var hasInitialLocation = false
 
    
    // Location Tracking
    private var locationManager: CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    override init() {
        super.init()
        
        //Request authorization for location data.
        Task {
            await MainActor.run {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func startRun() {
        presentRunView = true
        isRunning = true
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        elapsedTime = 0
        startTime = .now
        currentSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else{return}
            self.elapsedTime += 1
            if self.distance > 0 {
                let miles = self.distance * 3.28084 / 5280
                pace = (Double(self.elapsedTime) / 60) / miles
            } else {
                pace = 0.0
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func stopRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = false
        
        if let currentLocation = currentLocation {
            let newRegion = MKCoordinateRegion(
                center: currentLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            DispatchQueue.main.async { [weak self] in
                self?.region = newRegion
            }
        }
        
        timer?.invalidate()
        timer = nil
        postToHealthStore()
        postToDatabase()
    }
    
    func postToDatabase() {
        Task {
            do {
                guard let userId = AuthService.shared.currentSession?.user.id else { return }
                let run = RunPayload(createdAt: .now, userId: userId, distance: distance, pace: pace, time: elapsedTime, route: convertToGeoJSONCoordinates(locations: locations))
                try await DatabaseService.shared.saveWorkout(run: run)
            } catch{
                print(error.localizedDescription)
            }
        }
    }
    
    func postToHealthStore() {
        Task {
            do {
                try await HealthManager.shared.addWorkout(startDate: startTime, endDate: .now, duration: Double(elapsedTime), distance: distance, calBurned: calculateCalsBurned())
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func calculateCalsBurned() -> Double {
        let weight: Double = 180.0
        let duration = Double(elapsedTime) / 3600.0
        let miles = distance * 3.28084 / 5280

        guard duration > 0 else { return 0 }
        
        let speedMph = miles / duration

        // Standard MET values for running based on speed
        let MET: Double
        switch speedMph {
        case 0..<4.0:     MET = 6.0   // Jogging, general
        case 4.0..<5.0:   MET = 8.3   // Running 4 mph
        case 5.0..<5.2:   MET = 9.0   // Running 5 mph
        case 5.2..<6.0:   MET = 10.0  // Running 5.2 mph
        case 6.0..<6.7:   MET = 11.0  // Running 6 mph
        case 6.7..<7.0:   MET = 11.5  // Running 6.7 mph
        case 7.0..<7.5:   MET = 12.5  // Running 7 mph
        case 7.5..<8.0:   MET = 13.3  // Running 7.5 mph
        case 8.0..<9.0:   MET = 14.5  // Running 8 mph
        case 9.0..<10.0:  MET = 16.0  // Running 9 mph
        case 10.0..<11.0: MET = 19.0  // Running 10 mph
        default:          MET = 23.0  // Running >11 mph
        }
        
        // Calories = MET × weight(kg) × duration(hours)
        let calories = MET * (weight / 2.2) * duration
        return calories
    }
    
    func pauseRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = true
        
        timer?.invalidate()
    }
    
    func resumeRun() {
        isRunning = true
        presentPauseView = false
        presentRunView = true
        startLocation = nil
        lastLocation = nil
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else{return}
            self.elapsedTime += 1
            if self.distance > 0 {
                let miles = self.distance * 3.28084 / 5280
                pace = (Double(self.elapsedTime) / 60) / miles
            } else {
                pace = 0.0
            }
        }
        locationManager?.startUpdatingLocation()
    }
}

// MARK: Location Tracking
extension RunTracker: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        // Always update current location for map positioning
        currentLocation = location.coordinate
        
        // Update region based on current state
        if !hasInitialLocation {
            // First location - set initial region
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                self.hasInitialLocation = true
            }
        } else if isRunning && !presentPauseView {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.currentSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: self.currentSpan
                )
            }
        } else if presentPauseView {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: self.currentSpan
                )
            }
        } else if !isRunning && !presentPauseView && hasInitialLocation {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        }
        
        if isRunning {
            self.locations.append(location.coordinate)
            
            if startLocation == nil {
                startLocation = location
                lastLocation = location
                return
            }
            if let lastLocation {
                distance += lastLocation.distance(from: location)
            }
            lastLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

func convertToGeoJSONCoordinates(locations: [CLLocationCoordinate2D]) -> [GeoJSONCoordinate]{
    return locations.map {GeoJSONCoordinate(longitude: $0.longitude, latitude: $0.latitude) }
}
