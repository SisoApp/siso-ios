//
//  FullScreenProfileView.swift
//  matching
//
//  Created by jdios on 8/20/25.
//

import SwiftUI

struct FullScreenProfileView: View {
    @ObservedObject var cardViewModel: CardViewModel
    var body: some View {
        ZStack {
            TabView {
                ForEach(cardViewModel.profileImages,id: \.self) { url in
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                        
                    } placeholder: {
                        ProgressView()
                    }
                }
            }.tabViewStyle(.page)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        
    }
}

#Preview {
    FullScreenProfileView(cardViewModel: CardViewModel.testModel)
}
