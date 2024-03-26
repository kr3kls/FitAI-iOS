//
//  BodyView.swift
//  FitAI
//
//  Created by Craig Troop on 3/11/24.
//

import SwiftUI
import SwiftData

struct BodyView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    @Binding var view: String
    @Binding var selectedRestaurant: Restaurant
    
    var body: some View {
        ViewLoader(view: view)
    }
    
    @ViewBuilder func ViewLoader(view: String) -> some View {
        if !users.isEmpty {
            let user = users[0]
            
            switch view {
            case "ProfileView":
                ProfileView(view: $view)
            case "EditUserView":
                EditUserView(view: $view, user: user)
            case "RestaurantListView":
                RestaurantListView(view: $view, selectedRestaurant: $selectedRestaurant)
            case "MenuDetailView":
                MenuDetailView(selectedRestaurant: $selectedRestaurant)
            case "FeedbackView":
                FeedbackView()
            default:
                EmptyView()
            }
        } else {
            switch view {
            case "ProfileView":
                ProfileView(view: $view)
            case "EditUserView":
                let user = addUser()
                EditUserView(view: $view, user: user)
            case "RestaurantListView":
                RestaurantListView(view: $view, selectedRestaurant: $selectedRestaurant)
            case "FeedbackView":
                FeedbackView()
            default:
                EmptyView()
            }
        }

    }
    
    func addUser() -> User {
        let user = User(name: "", age: 18, height: 68, weight: 145, sex: "Male", fitnessGoal: "Lose Weight")
        modelContext.insert(user)
        return user
    }
}

//#Preview {
//    BodyView()
//}
