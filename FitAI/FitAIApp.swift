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
    @State private var view: String = "ProfileView"
    @State private var selectedRestaurant: Restaurant = Restaurant(id: 0, name: "", address: "", latitude: "", longitude: "")
    
    var body: some Scene {
        WindowGroup {
            ContentView(view: $view, selectedRestaurant: $selectedRestaurant)
                .environmentObject(healthService)
        }
        .modelContainer(for: User.self)
    }
}
