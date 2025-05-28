//
//  HealthManager.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import Foundation
import HealthKit

final class HealthManager {
    let healthStore = HKHealthStore()
    
    static let shared = HealthManager()
    private init() {    }
    func requestAuthorization() async throws {
        let typesToShare: Set = [HKWorkoutType.workoutType()]
        try await healthStore.requestAuthorization(toShare: typesToShare, read: [])
    }
    func addWorkout(startDate: Date, endDate: Date, duration: TimeInterval, distance: Double, calBurned: Double) async throws {
        let workout = HKWorkout(activityType: .running,
                                start: startDate,
                                end: endDate,
                                duration: duration,
                                totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: calBurned),
                                totalDistance: HKQuantity(unit: .meter(), doubleValue: distance),
                                device: .local(),
                                metadata: nil)
        try await healthStore.save(workout)
    }
}
