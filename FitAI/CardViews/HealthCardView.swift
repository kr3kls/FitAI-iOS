//
//  HealthCardView.swift
//  FitAI
//
//  Created by Craig Troop on 3/6/24.
//

import SwiftUI

struct HealthCardView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Daily Steps")
                        .font(.system(size: 16))
                
                    Text("Goal: 10,000")
                        .font(.system(size: 12))
                }
                Spacer()
                
                Image(systemName: "figure.walk")
                    .foregroundColor(.green)
            }
            .padding()
            
            Text("5,237")
                .font(.system(size: 24))
                .foregroundColor(.gray)
        }
        .padding()
        .cornerRadius(15)
    }
}

#Preview {
    HealthCardView()
}
