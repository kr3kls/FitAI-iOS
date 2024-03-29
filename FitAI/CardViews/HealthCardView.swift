//
//  HealthCardView.swift
//  FitAI
//
//  Created by Craig Troop on 3/6/24.
//

import SwiftUI

struct HealthCard {
    let id: Int
    let label: String
    let subLabel: String
    let icon: String
    let data: String
    let iconColor: Color
}

struct HealthCardView: View {
    @State var healthCard: HealthCard
    
    var body: some View {
        ZStack {
            Color("FitLightBlue")
                .cornerRadius(15)
            
            VStack(spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(healthCard.label)
                            .font(.custom("LeagueSpartan-Bold", size: 18))
                            .foregroundStyle(Color("FitDarkBlue"))
                        
                        Text(healthCard.subLabel)
                            .font(.custom("Koulen-Regular", size: 18))
                    }
                    Spacer()
                    
                    Image(systemName: healthCard.icon)
                        .foregroundStyle(healthCard.iconColor)
                        .shadow(color: .black, radius: 5, x: 2, y: 2)
                }
                
                Text(healthCard.data)
                    .font(.custom("LeagueSpartan-Bold", size: 24))
                    .foregroundStyle(Color("FitDarkBlue"))
                    .padding(.horizontal)
            }
            .padding()
        }
        .padding()
    }
}

// #Preview {
//     HealthCardView(healthCard: HealthCard(id: 0, label: "Daily Steps", subLabel: "Goal: 10,000", icon: "figure.walk", data: "5,327", iconColor: .green))
// }
