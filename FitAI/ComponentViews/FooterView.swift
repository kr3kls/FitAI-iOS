//
//  FooterView.swift
//  FitAI
//
//  Created by Craig Troop on 3/11/24.
//

import SwiftUI

struct FooterView: View {
    @Binding var view: String
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                               
                Spacer()
                
                Image("profile")
                    .resizable()
                    .frame(maxWidth: 66, maxHeight: 50)
                    .padding()
                    .colorMultiply(view == "ProfileView" ? Color("FitGreen") : .white)
                    .offset(x: 0, y: 5)
                    .onTapGesture {
                        view = "ProfileView"
                    }
                
                Spacer()
                
                Image("restaurants")
                    .resizable()
                    .frame(maxWidth: 45, maxHeight: 50)
                    .padding()
                    .colorMultiply(view == "RestaurantListView" ? Color("FitGreen") : .white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                    .onTapGesture {
                        view = "RestaurantListView"
                    }
                
                Spacer()
                
                Image("feedback")
                    .resizable()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .padding()
                    .colorMultiply(view == "FeedbackView" ? Color("FitGreen") : .white)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                    .onTapGesture {
                        view = "FeedbackView"
                    }
                
                Spacer()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("FitDarkBlue"))
    }
}

//#Preview {
//    FooterView()
//}
