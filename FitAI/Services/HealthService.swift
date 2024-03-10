//
//  HealthService.swift
//  FitAI
//
//  Created by Craig Troop on 3/6/24.
//

import Foundation
import HealthKit


class HealthService: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @Published var activities: [String: HealthCard] = [:]
    
    init() {
        let dailySteps = HKQuantityType(.stepCount)
        let activeCalories = HKQuantityType(.activeEnergyBurned)
        
        let healthTypes: Set = [dailySteps, activeCalories]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch {
                print("Error fetching health data")
            }
        }
    }
    
    func fetchDailySteps() {
        let dailySteps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: dailySteps, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching daily steps.")
                return
            }
            
            let stepCount = quantity.doubleValue(for: .count())
            let activity = HealthCard(id: 0, label: "Daily Steps", subLabel: "Goal: 10,000", icon: "figure.walk", data: stepCount.formattedString(), iconColor: .green)
            DispatchQueue.main.async {
                self.activities["dailySteps"] = activity
            }
            
            print(stepCount)
        }
        
        healthStore.execute(query)
    }
    
    func fetchActiveCalories() {
        let activeCalories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: activeCalories, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching active calories.")
                return
            }
            
            let calories = quantity.doubleValue(for: .kilocalorie())
            let activity = HealthCard(id: 1, label: "Active Calories", subLabel: "Goal: 800", icon: "flame", data: calories.formattedString(), iconColor: .orange)
            DispatchQueue.main.async {
                self.activities["activeCalories"] = activity
            }
            
            print(calories)
        }
        
        healthStore.execute(query)
    }
    
    func fetchHealthData() {
        fetchDailySteps()
        fetchActiveCalories()
    }
}

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

extension Double {
    func formattedString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
