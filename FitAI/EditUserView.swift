//
//  EditUserView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

struct EditUserView: View {
    @Bindable var user: User
    
    let fitnessGoals = ["Lose Weight", "Maintain Weight", "Gain Weight", "Build Muscle", "Improve Fitness"]
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $user.name)
                    .textContentType(.name)
                
                Picker("Age", selection: $user.age) {
                    ForEach(Array(18...100), id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Height", selection: $user.height) {
                    ForEach(Array(30...96), id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Weight", selection: $user.weight) {
                    ForEach(Array(50...500), id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Sex", selection: $user.sex) {
                    ForEach(["Male", "Female"], id: \.self) { choice in
                        Text(choice).tag(choice)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Fitness Goal", selection: $user.fitnessGoal) {
                    ForEach(fitnessGoals, id: \.self) { goal in
                        Text(goal).tag(goal)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    EditUserView()
//}
