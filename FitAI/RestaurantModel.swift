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
    let address: String
    let latitude: String
    let longitude: String
//    let latitude: String = "40.79747785312693"
//    let longitude: String = "-77.8576587539695"
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "restaurant_name"
        case address = "address"
        case latitude = "latitude"
        case longitude = "longitude"
    }
}
