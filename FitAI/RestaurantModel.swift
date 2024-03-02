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
    let address: String = "324 E College Ave, 16801"
//    let latitude: String
//    let longitude: String
    let latitude: String = "40.79747785312693"
    let longitude: String = "-77.8576587539695"
    var lastLoaded: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "restaurant_name"
        case itemCount = "itemCount"
//        case address = "address"
//        case latitude = "latitude"
//        case longitude = "longitude"
    }
}
