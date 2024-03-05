//
//  MenuItemModel.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import Foundation
import CoreML

class MenuItem: ObservableObject, Identifiable, Decodable {
    let id: Int
    let name: String
    let calories: String
    let fat: String
    let carbs: String
    let protein: String
    var category: Int
    @Published var reason: String
    @Published var isExpanded: Bool = false
    @Published var isLoadingDetail: Bool = true
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "menu_item"
        case calories = "Calories"
        case fat = "Fat"
        case carbs = "Carbs"
        case protein = "Protein"
        case category = "Category"
        case reason = "Reason"
        case isExpanded
        case isLoadingDetail
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(String.self, forKey: .calories)
        fat = try container.decode(String.self, forKey: .fat)
        carbs = try container.decode(String.self, forKey: .carbs)
        protein = try container.decode(String.self, forKey: .protein)
        category = 0
        reason = ""
        self.isExpanded = false
        self.isLoadingDetail = true
    }
    
    init(id: Int, name: String, calories: String, fat: String, carbs: String, protein: String, category: Int, reason: String, isExpanded: Bool, isLoadingDetail: Bool) {
        self.id = id
        self.name = name
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.category = category
        self.reason = reason
        self.isExpanded = isExpanded
        self.isLoadingDetail = isLoadingDetail
    }
}

class MenuResponse: ObservableObject, Decodable {
    @Published var menuItems: [MenuItem]

    private enum CodingKeys: String, CodingKey {
        case menuItems = "MenuItems"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        menuItems = try container.decode([MenuItem].self, forKey: .menuItems)
    }
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
