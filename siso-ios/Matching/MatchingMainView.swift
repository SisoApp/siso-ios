//
//  MatchingMainView.swift
//  matching
//
//  Created by jdios on 8/11/25.
//

import SwiftUI

struct MatchingMainView: View {
    let cardviewArray: [MatchingCardView] = Array(repeating: .init(), count: 10)
    var body: some View {
        VStack {
            ForEach(cardviewArray) { array in
                array()
            }
        }
    }
}


struct MatchingCardView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray)
                .ignoresSafeArea()
            
            HStack {
                VStack {
                    Image(systemName: "waveform")
                    Text("김갑돌")
                        .font(.largeTitle)
                    Text("서울 중구")
                        .font(.callout)
                    Text("#운동 #투자")
                        .font(.caption)
                }
                Spacer()
                
                Image(systemName: "phone.circle.fill")
                    
            }
            .padding()
            
        }
    }
}
