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

class RunTracker: NSObject, ObservableObject {
    let blueGray = Color(red: 0.4, green: 0.55, blue: 0.7)

    @Published var region = MKCoordinateRegion(center: .init(latitude: 40.7128, longitude: -74.0060), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @Published var isRunning = false
    @Published var presentCountdown = false
    @Published var presentRunView = false
    @Published var presentPauseView = false
    @Published var distance = 0.0
    @Published var pace = 0.0
    @Published var elapsedTime = 0
    private var timer: Timer?
    
 
    
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
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else{return}
            self.elapsedTime += 1
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60) / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    func stopRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
    }
    func pauseRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = true
        locationManager?.stopUpdatingLocation()
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
                pace = (Double(self.elapsedTime) / 60) / (self.distance / 1000)
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
        DispatchQueue.main.async { [weak self] in
            self?.region.center = location.coordinate
        }
        
        
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
