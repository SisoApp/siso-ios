//
//  MatchingCallingView.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI

struct MatchingCallingView: View {
    @StateObject var cardViewModel: CardViewModel
    @StateObject var callManager: CallManager
    var body: some View {
        VStack {
            profileImageView
            
            userInfoSection
            
            locationInfoSection
            
            interestTagsSection
            
            introductionSection
            
            actionButtonsSection
        }
    }
    
    private var profileImageView: some View {
        ZStack {
            Group {
                Rectangle()
                
                TabView() {
                    ForEach(cardViewModel.profileImages,id: \.self) { url in
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
            }
            .frame(maxWidth: .infinity, maxHeight: 242)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
        }
        
    }
    /// 사용자 이름과 나이를 표시하는 뷰
    private var userInfoSection: some View {
        HStack {
            Group {
                Text("\(cardViewModel   .nickname),")
                Text("\(cardViewModel.age)세")
            }
            .font(.system(size: 24, weight: .bold, design: .default))
            .foregroundStyle(.black)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 위치 정보를 표시하는 뷰
    private var locationInfoSection: some View {
        HStack {
            Image("locationicon_inverse")
            Text(cardViewModel.location)
                .foregroundStyle(.black) // 배경이 어두울 것을 가정
            Spacer()
        }
        .padding(.horizontal)
    }
    
    
    /// 관심사 태그들을 표시하는 뷰
    private var interestTagsSection: some View {
        HStack {
            // Group은 ForEach가 여러 뷰를 생성할 때 컨테이너 역할을 합니다. 여기서는 생략 가능.
            ForEach(cardViewModel.interestTags.prefix(3), id: \.self) { interest in // 태그가 너무 많으면 잘릴 수 있으므로 prefix 사용 고려
                HStack(spacing: 2) {
                    Text("#")
                        .foregroundStyle(.black)
                    Text(interest)
                        .foregroundStyle(.black)
                }
                .font(.system(size: 18))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.gray.opacity(0.2))
                .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 자기소개 텍스트를 표시하는 뷰
    private var introductionSection: some View {
        Text(cardViewModel.introduction)
            .foregroundStyle(.black)
            .font(.system(size: 18))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .onTapGesture {
                print ("show all text")
            }
    }
    
    /// 하단 액션 버튼 (메시지, 통화) 뷰
    private var actionButtonsSection: some View {
        HStack {
            Button {
                callManager.quitCall()
            } label: {
                
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 96)
                    .foregroundStyle(Color.Siso.Red._60)
                    .overlay {
                        VStack{
                            Image("quitcallicon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            Text("통화 종료")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
            }
            Spacer()
            
            Button {
                callManager.isMuteMode.toggle()
            } label: {
                
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .foregroundStyle(Color.Siso.Gray._50)
                    .overlay {
                        VStack {
                            Image(systemName: "speaker.slash.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            Text("음소거")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                
            }
            
            Button {
                callManager.isSpeakerMode.toggle()
            } label: {
                
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .foregroundStyle(Color.Siso.Blue._50)
                    .overlay {
                        VStack {
                            Image(systemName: "phone.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            Text("스피커")
                                .foregroundStyle(.white)
                                .font(.system(size: 18, weight: .semibold))
                        }
                        
                    }
                
                
            }
        }
        .frame(height: 80)
        .padding(.horizontal)
    }
}


// #Preview는 기존과 동일합니다.
#Preview {
    let cardViewModel = CardViewModel(
        nickname: "삼성전자회장이나야",
        age: 58,
        isOnline: true,
        interestTags: ["여행✈️", "사진", "카페투어"],
        profileImages: [
            URL(string: "https://picsum.photos/seed/jane4/600/400")!,
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane2/400/600")!,
            URL(string: "https://picsum.photos/seed/jane3/400/600")!
        ],
        voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
        introduction: "안녕하세요! 좋은 인연을 찾고 있어요. 함께 맛있는 거 먹으러 다녀요. SwiftUI는 재밌지만 가끔은 어렵네요. 그래도 열심히 공부하고 있습니다. 같이 코딩하실 분도 환영!",
        location: "인천 미추홀구"
    )
    MatchingCallingView(cardViewModel: cardViewModel, callManager: CallManager())
    
}
