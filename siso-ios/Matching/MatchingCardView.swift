//
//  CardView.swift
//  auth
//
//  Created by jdios on 8/13/25.
//

import SwiftUI

struct MatchingCardView: View {
    @StateObject var cardViewModel: CardViewModel
    @State var isPlaying = false
    let data: User
    var body: some View {
        VStack {
            HStack {
                Text("nickname is here")
                    .font(Font.appFont(name: .regular, size: 17))
                
                Circle().fill(Color.green)
                    .frame(width: 10, height: 10)
            }
            HStack {
                Button {
                    print("playtoggle")
                    isPlaying.toggle()
                } label: {
                    isPlaying ? Image(systemName: "pause.fill") : Image(systemName: "play.fill")
                    
                }
                
                WaveformView(count: 10, height: 30, isPlaying: $isPlaying)
                    .frame(width: 100)
                
            }
        }
    }
}




#Preview {
    let sampleUser = User.init(socailLogin: "카카오", phoneNumber: "01083316520", isOnline: true, isNotificationSubscribed: true, refreshtoken: "available", isBlock: false, isDeleted: false, createdAt: "20250813", updatedAt: "20250813")
    MatchingCardView(cardViewModel: <#CardViewModel#>, data: sampleUser)
}
