//
//  ContentView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var users: [User]
    @Binding var view: String
    @Binding var selectedRestaurant: Restaurant
    
    var body: some View {

        VStack {
            HeaderView()
                .frame(maxWidth: .infinity, maxHeight: 100)
            Spacer()
                .frame(height: 10)
            
            BodyView(view: $view, selectedRestaurant: $selectedRestaurant)
            
            Spacer()
                .frame(height: 10)
            
            FooterView(view: $view)
                .frame(maxWidth: .infinity, maxHeight: 100)
        }
    }
}

//#Preview {
//    ContentView(view: "ProfileView")
//}
