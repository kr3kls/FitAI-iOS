//
//  RestaurantListView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

struct RestaurantListView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    @State private var restaurants: [Restaurant] = []
    @State private var isLoading: Bool = true
    @Binding var view: String
    @Binding var selectedRestaurant: Restaurant
    
    var body: some View {
        
        if ( users.isEmpty ) {
            VStack{
                Spacer()
                
                Text("User Profile Not Found.")
                
                Spacer()
                    .frame(height: 50)
                
                Text("Please create user profile before searching restaurants.")
                
                Spacer()
            }
        } else {
            let user = users[0]
            if ( user.badAgeFlag || user.badHeightFlag || user.badWeightFlag ) {
                VStack{
                    Spacer()
                    
                    Text("User Profile Incomplete.")
                    
                    Spacer()
                        .frame(height: 50)
                    
                    Text("Please update user profile before searching restaurants.")
                    
                    Spacer()
                }
            } else {
                VStack {
                    if isLoading {
                        Spacer()
                        ProgressView("Loading...")
                            .onAppear {
                                fetchRestaurants()
                            }
                        Spacer()
                    } else {
                        
                        ScrollView {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(Color("FitLightBlue"))
                                    .padding()
                                
                                VStack(spacing: 0) {
                                    Spacer()
                                        .frame(height: 40)
                                    HStack(spacing: 0) {
                                        Text("Nearby Restaurants")
                                            .font(.custom("LeagueSpartan-Bold", size: 24))
                                            .foregroundStyle(Color("FitDarkBlue"))
                                            .padding(.horizontal, 50)
                                        Spacer()
                                    }
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15.0)
                                            .fill(.white)
                                            .padding()
                                        VStack(spacing: 5) {
                                            Spacer()
                                            ForEach(restaurants) { restaurant in
                                                HStack {
                                                    Text(restaurant.name)
                                                        .font(.custom("Koulen-Regular", size: 18))
                                                    Spacer()
                                                    Text(">")
                                                        .font(.custom("Koulen-Regular", size: 24))
                                                        .foregroundStyle(Color("FitDarkBlue"))
                                                        .multilineTextAlignment(.trailing)
                                                }
                                                .padding(.horizontal, 20)
                                                .onTapGesture {
                                                    selectedRestaurant = restaurant
                                                    view = "MenuDetailView"
                                                }
                                                Rectangle()
                                                    .frame(height: 1)
                                                    .foregroundColor(Color("FitDarkBlue"))
                                                    .padding(.horizontal)
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
