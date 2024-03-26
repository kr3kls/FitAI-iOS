//
//  UserModel.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import Foundation
import SwiftData

@Model
class User {
    var name: String
    var age: Int
    var height: Int
    var weight: Int
    var sex: String
    var fitnessGoal: String
    var validated: Bool = false
    var badAgeFlag: Bool = false
    var badHeightFlag: Bool = false
    var badWeightFlag: Bool = false
    
    init(name: String, age: Int, height: Int, weight: Int, sex: String, fitnessGoal: String) {
        self.name = name
        self.age = age
        self.height = height
        self.weight = weight
        self.sex = sex
        self.fitnessGoal = fitnessGoal
    }
}
