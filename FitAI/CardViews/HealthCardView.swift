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
            Color(uiColor: .systemGray6)
                .cornerRadius(15)
            
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(healthCard.label)
                            .font(.system(size: 16))
                        
                        Text(healthCard.subLabel)
                            .font(.system(size: 12))
                    }
                    Spacer()
                    
                    Image(systemName: healthCard.icon)
                        .foregroundColor(healthCard.iconColor)
                }
                
                Text(healthCard.data)
                    .font(.system(size: 24))
                    .foregroundColor(healthCard.iconColor)
                    .padding()
            }
            .padding()
        }
    }
}

#Preview {
    HealthCardView(healthCard: HealthCard(id: 0, label: "Daily Steps", subLabel: "Goal: 10,000", icon: "figure.walk", data: "5,327", iconColor: .green))
}
