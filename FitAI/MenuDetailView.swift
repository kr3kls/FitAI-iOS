//
//  MenuDetailView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import CoreML

struct MenuDetailView: View {
    var restaurant: Restaurant
    @StateObject private var menuResponse = MenuResponse()
    @State private var isLoading: Bool = true
    var user: User?
    
    var body: some View {
        NavigationView {
            VStack {
                Link(destination: mapURL()) {
                    Text("\(restaurant.address)").font(.subheadline)
                }
                MapView(restaurant: restaurant)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 4)
                    }
                    .shadow(radius: 7)
                    .padding(10)
                
                if isLoading {
                    Spacer()
                    ProgressView("Fitting...")
                        .onAppear {
                            fetchMenu(for: restaurant, user: user)
                        }
                    Spacer()
                } else {
                    List(menuResponse.menuItems.indices, id: \.self) { index in
                        if let item = safeIndex(index) {
                            VStack(alignment: .leading) {
                                Button(action: {
                                    toggleExpansion(for: index)
                                }) {
                                    Text(item.name)
                                        .foregroundColor(textColor(for: item.category))
                                }
                                
                                if item.isExpanded {
                                    Text("Calories: \(item.calories) • Fat: \(item.fat)g • Carbs: \(item.carbs)g • Protein: \(item.protein)g")
                                        .font(.caption)
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                        .padding(.top, 5)
                                    if item.isLoadingDetail {
                                        ProgressView("Fitting...")
                                    } else {
                                        Text(item.reason)
                                            .foregroundColor(.gray)
                                            .padding(.leading)
                                            .padding(.top, 5)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .navigationTitle("\(restaurant.name) Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func loadReason(for item: MenuItem, user: User?, restaurant: Restaurant) {
        guard let user = user else {
            print("User not found")
            return
        }
        AWSMenuService.loadReason(for: item, user: user, restaurant: restaurant) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let reason):
                    item.reason = reason
                    item.isLoadingDetail = false
                case .failure(let error):
                    print("Error fetching item reason: \(error)")
                    item.reason = "Error loading reason"
                }
                
            }
        }
    }

    
    private func fetchMenu(for restaurant: Restaurant, user: User?) {
        guard let user = user else {
            print("User not found")
            return
        }
        
        AWSMenuService.fetchMenu(for: restaurant, user: user) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedMenuItems):
                    self.menuResponse.menuItems = self.categorize(menuItems: fetchedMenuItems.menuItems, user: user)
                    self.isLoading = false
                    self.menuResponse.menuItems.forEach { item in
                        self.loadReason(for: item, user: user, restaurant: restaurant)
                    }
                case .failure(let error):
                    print("Error fetching menu items: \(error)")
                }
            }
        }
    }

    private func categorize(menuItems: [MenuItem], user: User) -> [MenuItem] {
        let fitness_goals = ["Lose Weight", "Maintain Weight", "Gain Weight", "Build Muscle", "Improve Fitness"]
        if let goal = fitness_goals.firstIndex(of: user.fitnessGoal) {
            let model = try? xgb_cat(configuration: MLModelConfiguration())
            for (index, item) in menuItems.enumerated() {
                if let proteinDouble = Double(item.protein),
                   let caloriesDouble = Double(item.calories),
                   let fatDouble = Double(item.fat),
                   let carbsDouble = Double(item.carbs) {
                    do {
                        if let category_prediction = try? model?.prediction(Protein: proteinDouble, Calories: caloriesDouble, Fat: fatDouble, Carbohydrates: carbsDouble, FitnessGoal: Double(goal)) {
                            let category = category_prediction.target
                            menuItems[index].category = Int(category) + 1
                        }
                    }
                }
            }
        }
        return menuItems
        
    }
    
    private func safeIndex(_ index: Int) -> MenuItem? {
        return index >= 0 && index < menuResponse.menuItems.count ? menuResponse.menuItems[index] : nil
    }
    
    private func indexExists(_ index: Int) -> Bool {
            return index >= 0 && index < menuResponse.menuItems.count
        }
    
    private func toggleExpansion(for index: Int) {
        if indexExists(index) {
            menuResponse.menuItems[index].isExpanded.toggle()
            let updatedItems = menuResponse.menuItems
            menuResponse.menuItems = updatedItems
        }
    }
        
    private func textColor(for category: Int) -> Color {
        switch category {
        case 1:
            return .green
        case 2:
            return .yellow
        case 3:
            return .red
        default:
            return .black
        }
    }
    
    private func mapURL() -> URL {
        let encodedAddress = restaurant.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?address=\(encodedAddress)"
        return URL(string: urlString)!
    }
}

//#Preview {
//    MenuDetailView()
//}
