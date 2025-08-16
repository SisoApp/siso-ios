//
//  MatchingCallingView.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI

/// 전화가 걸리는 중인 뷰입니다
struct MatchingContactingView: View {
    @StateObject var cardViewModel: CardViewModel
    var body: some View {
        VStack{
            Spacer()
            Text("\(cardViewModel.nickname) 님과\n연결중이에요")
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding()

            CallingWaveformView(count: 15, height: 100, isplaying: true)
                .frame(width: 300)
                .padding()
           
            
            TabView {
                TalkTips
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .frame(height: 200)
            
            Spacer()
        }
        
    }
    
    private var TalkTips: some View {
        Group {
            Text("처음엔\n가볍고 따듯한 이야기로\n시작해보세요.")
            Text("서로 다른 점보다는 공감할 수\n있는 이야기를 먼저 나눠요.")
            Text("예의있는 대화를 나눌수록\n긍정적인 매칭결과를 보여요.")
            Text("취미, 관심사 등으로\n대화의 물꼬를 터봐요.")
            
        }.multilineTextAlignment(.center)
            .font(.system(size: 18))
            .foregroundStyle(Color.Siso.Gray._70)
    }
}


#Preview {
    let cardViewModel = CardViewModel(
        nickname: "삼성전자회장",
        age: 58,
        isOnline: true,
        interestTags: ["여행✈️", "사진", "카페투어"],
        profileImages: [
            
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane2/400/600")!,
            URL(string: "https://picsum.photos/seed/jane3/400/600")!
        ],
        voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
        introduction: "안녕하세요! 좋은 인연을 찾고 있어요. 함께 맛있는 거 먹으러 다녀요. SwiftUI는 재밌지만 가끔은 어렵네요. 그래도 열심히 공부하고 있습니다. 같이 코딩하실 분도 환영!",
        location: "인천 미추홀구"
    )
    MatchingContactingView(cardViewModel: cardViewModel)
}
