//
//  ContentView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
            
            RestaurantListView(userCount: users.count, user: users.first)
                .tabItem {
                    Image(systemName: "storefront.circle")
                    Text("Restaurants")
                }
            
            FeedbackView()
                .tabItem {
                    Image(systemName: "paperplane.circle")
                    Text("Feedback")
                }
        }
    }
}

//#Preview {
//    ContentView()
//}
