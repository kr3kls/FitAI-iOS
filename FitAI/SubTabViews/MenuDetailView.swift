//
//  MenuDetailView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData
import CoreML

struct MenuDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    @StateObject private var menuResponse = MenuResponse()
    @State private var isLoading: Bool = true
    @Binding var selectedRestaurant: Restaurant
    
    var body: some View {
        ScrollView {
            ZStack {
                RoundedRectangle(cornerRadius: 15.0)
                    .fill(Color("FitDarkBlue"))
                    .padding()
                VStack(spacing: 0) {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(selectedRestaurant.name)
                            .font(.custom("LeagueSpartan-Bold", size: 24))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(.white)
                                .padding()
                            HStack {
                                Link(destination: mapURL()) {
                                    Text("\(selectedRestaurant.address)")
                                        .font(.custom("Koulen-Regular", size: 14))
                                        .accentColor(.black)
                                }
                                .padding()
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    HStack {
                        MapView(restaurant: selectedRestaurant)
                            .frame(width: 250, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15).stroke(.gray, lineWidth: 4)
                            }
                            .shadow(radius: 7)
                            .padding(10)
                    }
                    Spacer()
                }
                .padding()
            }
            
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView("Fitting...")
                        .onAppear {
                            fetchMenu(for: selectedRestaurant, user: users[0])
                        }
                    Spacer()
                }
                .padding()
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
                        .fill(Color("FitLightBlue"))
                        .padding()
    
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 40)
                        HStack(spacing: 0) {
                            Text("Menu")
                                .font(.custom("LeagueSpartan-Bold", size: 36))
                                .foregroundColor(Color("FitDarkBlue"))
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 15.0)
                                .fill(.white)
                                .padding()
                            VStack(spacing: 0) {
                                Spacer()
                                ForEach(menuResponse.menuItems.indices, id: \.self) { index in
                                    if safeIndex(index) {
                                        HStack {
                                            MenuItemView(item: menuResponse.menuItems[index])
                                        }
                                        .padding(.horizontal, 20)
                                        .onTapGesture { toggleExpansion(for: index) }
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(Color("FitDarkBlue"))
                                            .padding()
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        .padding()
                    }
                }
            }
        }
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
    
    private func safeIndex(_ index: Int) -> Bool {
        return index >= 0 && index < menuResponse.menuItems.count ? true : false
    }
    
    private func indexExists(_ index: Int) -> Bool {
            return index >= 0 && index < menuResponse.menuItems.count
        }
    
    private func toggleExpansion(for index: Int) {
        if indexExists(index) {
            menuResponse.menuItems[index].isExpanded.toggle()
            if menuResponse.menuItems[index].isExpanded && menuResponse.menuItems[index].isLoadingDetail {
                loadReason(for: menuResponse.menuItems[index], user: users[0], restaurant: selectedRestaurant)
            }
            let updatedItems = menuResponse.menuItems
            menuResponse.menuItems = updatedItems
        }
    }
    
    private func mapURL() -> URL {
        let encodedAddress = selectedRestaurant.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?address=\(encodedAddress)"
        return URL(string: urlString)!
    }
}

//#Preview {
//    MenuDetailView()
//}
