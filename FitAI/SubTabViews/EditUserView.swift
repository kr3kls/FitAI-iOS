//
//  EditUserView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

struct EditUserView: View {
    @Binding var view: String
    @Bindable var user: User
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15.0)
                .fill(Color("FitGreen"))
                .padding()
            
            VStack(spacing: 0){
                Spacer()
                    .frame(height: 40)
                HStack(spacing: 0) {
                    Text("Edit User")
                        .font(.custom("LeagueSpartan-Bold", size: 24))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 50)
                    Spacer()
                    ZStack{
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(.white)
                            .padding(.horizontal, 10)
                        Text("Save")
                            .font(.custom("Koulen-Regular", size: 18))
                    }
                    .frame(maxWidth: 80, maxHeight: 30)
                    .onTapGesture {
                        view = "RestaurantListView"
                    }
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(.white)
                        .padding()
                    
                    VStack(spacing: 5){
                        Spacer()
                        HStack {
                            Text("Name: ")
                                .font(.custom("Koulen-Regular", size: 18))
                            TextField("Name", text: $user.name)
                                .textContentType(.name)
                                .font(.custom("Koulen-Regular", size: 18))
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal, 80)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("FitDarkBlue"))
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Age: ")
                                .font(.custom("Koulen-Regular", size: 18))
                            TextField("Age", text: Binding(
                                get: { String(user.age) },
                                set: { ageValidation(inputValue: $0) }
                            ))
                            .font(.custom("Koulen-Regular", size: 18))
                            .foregroundStyle(user.badAgeFlag ? .red : .black)
                            .multilineTextAlignment(.trailing)
                            .onAppear() {
                                print(user.badAgeFlag)
                            }
                        }
                        .padding(.horizontal, 80)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("FitDarkBlue"))
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Height: ")
                                .font(.custom("Koulen-Regular", size: 18))
                            TextField("Height", text: Binding(
                                get: { String(user.height) },
                                set: { heightValidation(inputValue: $0) }
                            ))
                            .font(.custom("Koulen-Regular", size: 18))
                            .foregroundStyle(user.badHeightFlag ? .red : .black)
                            .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal, 80)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("FitDarkBlue"))
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Weight: ")
                                .font(.custom("Koulen-Regular", size: 18))
                            TextField("Weight", text: Binding(
                                get: { String(user.weight) },
                                set: { weightValidation(inputValue: $0) }
                            ))
                            .font(.custom("Koulen-Regular", size: 18))
                            .foregroundStyle(user.badWeightFlag ? .red : .black)
                            .multilineTextAlignment(.trailing)
                        }
                        .padding(.horizontal, 80)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("FitDarkBlue"))
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Sex: ")
                                .font(.custom("Koulen-Regular", size: 18))
                            Spacer()
                            Text(user.sex)
                                .font(.custom("Koulen-Regular", size: 18))
                                .onTapGesture {
                                    toggleSex(user: user)
                                }
                        }
                        .padding(.horizontal, 80)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color("FitDarkBlue"))
                            .padding(.horizontal)
                        
                        HStack {
                            Text("Fitness Goal: ")
                                .font(.custom("Koulen-Regular", size: 18))
                            Spacer()
                            Text(user.fitnessGoal)
                                .font(.custom("Koulen-Regular", size: 18))
                                .onTapGesture {
                                    toggleGoal(user: user)
                                }
                        }
                        .padding(.horizontal, 60)
                        Spacer()
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
        func toggleSex(user: User) {
            switch user.sex{
                case "Male":
                    user.sex = "Female"
                case "Female":
                    user.sex = "Male"
                default:
                    user.sex = "Male"
            }
        }
    
    func toggleGoal(user: User) {
        switch user.fitnessGoal{
        case "Lose Weight":
            user.fitnessGoal = "Maintain Weight"
        case "Maintain Weight":
            user.fitnessGoal = "Gain Weight"
        case "Gain Weight":
            user.fitnessGoal = "Build Muscle"
        case "Build Muscle":
            user.fitnessGoal = "Improve Fitness"
        case "Improve Fitness":
            user.fitnessGoal = "Lose Weight"
        default:
            user.fitnessGoal = "Lose Weight"
        }
    }
    
    func ageValidation(inputValue: String) {
        if let newValue: Int = Int(inputValue) {
            user.age = newValue
            user.badAgeFlag = false
        } else {
            user.badAgeFlag = true
        }
    }
    
    func heightValidation(inputValue: String) {
        if let newValue: Int = Int(inputValue) {
            user.height = newValue
            user.badHeightFlag = false
        } else {
            user.badHeightFlag = true
        }
    }
    
    func weightValidation(inputValue: String) {
        if let newValue: Int = Int(inputValue) {
            user.weight = newValue
            user.badWeightFlag = false
        } else {
            user.badWeightFlag = true
        }
    }
}

//#Preview {
//    EditUserView()
//}
