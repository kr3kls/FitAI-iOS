//
//  MenuDetailView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI

struct MenuDetailView: View {
    var restaurant: Restaurant
    @StateObject private var menuResponse = MenuResponse()
    @State private var isLoading: Bool = true
    var user: User?
    
    var body: some View {
        NavigationView {
            if isLoading {
                ProgressView("Fitting...")
                    .onAppear {
                        fetchMenu(for: restaurant.id, user: user)
                    }
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
                                
                                Text(item.reason)
                                    .foregroundColor(.gray)
                                    .padding(.leading)
                                    .padding(.top, 5)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("\(restaurant.name) Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func fetchMenu(for restaurantID: Int, user: User?) {
        guard let user = user else {
            print("User not found")
            return
        }
        
        AWSMenuService.fetchMenu(for: restaurantID, user: user) { result in
            switch result {
            case .success(let menuResponse):
                DispatchQueue.main.async {
                    self.menuResponse.menuItems = menuResponse.menuItems
                    self.isLoading = false
                }
            case .failure(let error):
                print("Error fetching menu items: \(error)")
            }
        }
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
}

//#Preview {
//    MenuDetailView()
//}
