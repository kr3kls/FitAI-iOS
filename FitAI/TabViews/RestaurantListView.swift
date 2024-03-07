//
//  RestaurantListView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

struct RestaurantListView: View {
    @State private var restaurants: [Restaurant] = []
    @State private var isLoading: Bool = true
    var userCount: Int
    var user: User?
    
    var body: some View {
        
        if userCount > 0 {
            NavigationView {
                        if isLoading {
                            ProgressView("Loading...")
                                .onAppear {
                                    fetchRestaurants()
                                }
                        } else {
                            List(restaurants) { restaurant in
                                NavigationLink(destination: MenuDetailView(restaurant: restaurant, user: user)) {
                                    Text(restaurant.name)
                                }
                            }
                            .navigationTitle("Nearby Restaurants")
                        }
                    }
        } else {
            VStack{
                Spacer()
                
                Text("User Profile Not Found.")
                
                Spacer()
                    .frame(height: 50)
                
                Text("Please create user profile before searching restaurants.")
                    
                Spacer()
            }
            
        }
    }

    private func fetchRestaurants() {
        AWSRestaurantService.fetchRestaurants { restaurants in
            DispatchQueue.main.async {
                self.restaurants = restaurants
                self.isLoading = false
            }
        }
    }
}

//#Preview {
//    RestaurantListView(userCount: 1)
//}
