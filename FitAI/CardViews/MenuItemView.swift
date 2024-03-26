//
//  MenuItemView.swift
//  FitAI
//
//  Created by Craig Troop on 3/4/24.
//

import SwiftUI

struct MenuItemView: View {
    @StateObject var item: MenuItem
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text(item.name)
                    .font(.custom("LeagueSpartan-Bold", size: 18))
                    .foregroundColor(textColor(for: item.category))
                Spacer()
                if !item.isExpanded {
                    Image("infoButton")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            Spacer()
                .frame(height: 5)
            if item.isExpanded {
                
                Text("Calories: \(item.calories) • Fat: \(item.fat)g • Carbs: \(item.carbs)g • Protein: \(item.protein)g")
                    .font(.custom("LeagueSpartan-Bold", size: 12))
                    .foregroundColor(.black)
                    .padding(.top, 5)
                Spacer()
                if item.isLoadingDetail {
                    Spacer()
                    ProgressView("Fitting...")
                    Spacer()
                } else {
                    
                    Text(item.reason)
                        .font(.custom("Koulen-Regular", size: 14))
                        .foregroundStyle(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
            }
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
//    MenuItemView()
//}
