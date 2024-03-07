//
//  ProfileView.swift
//  FitAI
//
//  Created by Craig Troop on 3/6/24.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var healthService: HealthService
    @State private var path = [User]()
    @Query var users: [User]
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
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
                .frame(maxHeight: 75)
                VStack {
                    Text("Lets \(users[0].fitnessGoal) Together!")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                        ForEach(healthService.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                            HealthCardView(healthCard: item.value)
                        }
                    }
                    .padding(10)
                }
                .onAppear() {
                    healthService.fetchHealthData()
                }
                
                Spacer()
            }
            .background()
            
        }
    }
    
    func addUser() {
        let user = User(name: "", age: 18, height: 68, weight: 145, sex: "Male", fitnessGoal: "Lose Weight")
        modelContext.insert(user)
        path.append(user)
    }
}

//#Preview {
//    ProfileView()
//}
