//
//  FullScreenProfileView.swift
//  matching
//
//  Created by jdios on 8/20/25.
//

import SwiftUI

public struct FullScreenProfileView: View {
    public init(cardViewModel: CardViewModel) {
        self.cardViewModel = cardViewModel
    }
    @ObservedObject var cardViewModel: CardViewModel
    public var body: some View {
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
