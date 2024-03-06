//
//  FeedbackView.swift
//  FitAI
//
//  Created by Craig Troop on 2/20/24.
//

import SwiftUI

struct FeedbackView: View {
    var body: some View {
        VStack {
            Text("Fit.AI")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)
            
            Spacer()
            
            Image("Fit.AIapplogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            Spacer()
            Spacer()
                .frame(height: 20)
            Text("Let us know what you think!")
            Text("FitAI.Feedback@gmail.com")
            
            Spacer()

            
            
            Spacer()
            
            Image("powered-by-openai-badge-filled-on-dark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
        }
        .padding()
    }
}

#Preview {
    FeedbackView()
}
