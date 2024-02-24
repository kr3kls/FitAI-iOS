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
    let itemCount: Int
    var lastLoaded: Int = 0
    var lattitude: Double = 40.797591560809494
    var longitude: Double = -77.85774458465599
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "restaurant_name"
        case itemCount = "itemCount"
    }
}
