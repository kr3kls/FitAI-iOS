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
        }
        .navigationTitle("\(restaurant.name) Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func fetchMenu(for restaurant: Restaurant, user: User?) {
        guard let user = user else {
            print("User not found")
            return
        }
        
        AWSMenuService.fetchMenu(for: restaurant, user: user) { result in
            switch result {
            case .success(let menuResponse):
                DispatchQueue.main.async {
                    self.menuResponse.menuItems = menuResponse.menuItems
                    self.isLoading = false
                }
                if let maxIdItem = menuResponse.menuItems.max(by: { $0.id < $1.id }) {
                    let maxValue = maxIdItem.id
                    self.restaurant.lastLoaded = maxValue
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
    
    private func mapURL() -> URL {
        let encodedAddress = restaurant.address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "http://maps.apple.com/?address=\(encodedAddress)"
        return URL(string: urlString)!
    }
}

//#Preview {
//    MenuDetailView()
//}
