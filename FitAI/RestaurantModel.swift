//
//  RestaurantModel.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import Foundation

class Restaurant: Identifiable, Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "restaurant_name"
    }
}
