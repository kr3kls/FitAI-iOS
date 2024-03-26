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
    @Query var users: [User]
    @Binding var view: String
    @State private var trigger: Bool = false

    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(Color("FitDarkBlue"))
                .padding()
            
            VStack {
                Spacer()
                    .frame(height: 40)
                HStack {
                    Text("Current User")
                        .font(.custom("LeagueSpartan-Bold", size: 24))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 50)
                    Spacer()
                }
                
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(.white)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 25)
                    
                    if users.isEmpty {
                        HStack {
                            Text("Tap to set profile")
                                .font(.custom("Koulen-Regular", size: 24))
                                .padding(.horizontal, 45)
                            Spacer()
                        }
                    } else {
                        HStack {
                            let user = users[0]
                            Text(user.name)
                                .font(.custom("Koulen-Regular", size: 24))
                                .padding(.horizontal, 45)
                            Spacer()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 175)
        .onTapGesture {
            if users.isEmpty {
                addUser()
            }
            view = "EditUserView"
        }
        
        VStack {
            Spacer()
            ForEach(healthService.activities.sorted(by: { $0.value.id < $1.value.id }), id: \.key) { item in
                HealthCardView(healthCard: item.value)
                    .frame(height: 100)
                    .padding(10)
                Spacer()
            }
        }
        .onAppear() {
            healthService.fetchHealthData()
        }
        
    }
    
    func addUser() {
        let user = User(name: "Name", age: 18, height: 68, weight: 145, sex: "Male", fitnessGoal: "Lose Weight")
        modelContext.insert(user)
    }
}

//#Preview {
//    ProfileView()
//}
