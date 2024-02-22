//
//  MenuItemModel.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import Foundation

class MenuItem: ObservableObject, Identifiable, Decodable {
    let id: Int
    let name: String
    let calories: Int
    let fat: Int
    let carbs: Int
    let protein: Int
    var category: Int
    var reason: String
    @Published var isExpanded: Bool = false
    
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
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        calories = try container.decode(Int.self, forKey: .calories)
        fat = try container.decode(Int.self, forKey: .fat)
        carbs = try container.decode(Int.self, forKey: .carbs)
        protein = try container.decode(Int.self, forKey: .protein)
        category = try container.decode(Int.self, forKey: .category)
        reason = try container.decode(String.self, forKey: .reason)
        self.isExpanded = false
    }
    
    init(id: Int, name: String, calories: Int, fat: Int, carbs: Int, protein: Int, category: Int, reason: String, isExpanded: Bool) {
        self.id = id
        self.name = name
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.category = category
        self.reason = reason
        self.isExpanded = isExpanded
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
