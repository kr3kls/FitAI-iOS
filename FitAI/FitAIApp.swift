//
//  FitAIApp.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

@main
struct FitAIApp: App {
    @StateObject var healthService = HealthService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthService)
        }
        .modelContainer(for: User.self)
    }
}
