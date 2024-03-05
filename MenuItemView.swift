//
//  MenuItemView.swift
//  FitAI
//
//  Created by Craig Troop on 3/4/24.
//

import SwiftUI

struct MenuItemView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.name)
                .foregroundColor(textColor(for: item.category))
            if item.isExpanded {
                Text("Calories: \(item.calories) • Fat: \(item.fat)g • Carbs: \(item.carbs)g • Protein: \(item.protein)g")
                    .font(.caption)
                    .foregroundColor(.black)
                    .padding(.leading)
                    .padding(.top, 5)
                if item.isLoadingDetail {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView("Fitting...")
                            Spacer()
                        }
                        Spacer()
                    }
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

#Preview {
    MenuItemView()
}
