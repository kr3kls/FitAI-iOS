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
    @State private var path = [User]()
    @Query var users: [User]
    
    var body: some View {
        TabView {
            NavigationStack(path: $path) {

                List {
                    if users.isEmpty {
                        Text("Tap the + to create a user profile.")
                    }
                    ForEach(users) { user in
                        NavigationLink(value: user) {
                            Text(user.name)
                        }
                    }
                }
                .navigationTitle("FitAI")
                .navigationDestination(for:
                                        User.self) { user in
                    EditUserView(user: user)
                }
                .toolbar {
                    if users.isEmpty{
                        Button("Add User", systemImage: "plus", action: addUser)
                    }
                }
            }
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
    
    func addUser() {
        let user = User(name: "", age: 18, height: 68, weight: 145, sex: "Male", fitnessGoal: "Lose Weight")
        modelContext.insert(user)
        path.append(user)
    }
}

//#Preview {
//    ContentView()
//}
