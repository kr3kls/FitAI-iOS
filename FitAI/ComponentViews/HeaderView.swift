//
//  HeaderView.swift
//  FitAI
//
//  Created by Craig Troop on 3/11/24.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            ZStack {
                Text("FIT.AI")
                    .font(.custom("LeagueSpartan-Bold", size: 36))
                    .foregroundStyle(.white)
                
                HStack {
                    Spacer()
                    Image("logo-2")
                        .resizable()
                        .frame(maxWidth: 60, maxHeight: 60)
                        .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("FitDarkBlue"))
    }
}

// #Preview {
//     HeaderView()
// }
