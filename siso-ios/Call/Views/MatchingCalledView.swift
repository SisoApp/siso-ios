//
//  CalledView.swift
//  matching
//
//  Created by jdios on 8/15/25.
//

import SwiftUI
import designSystem

public struct MatchingCalledView: View {
    @ObservedObject var cardViewModel: CardViewModel
    
    
    var delegate: MatchingCoordinatorDelegate?
    public init(cardViewModel: CardViewModel, delegate: MatchingCoordinatorDelegate? = nil){
        self._cardViewModel = .init(wrappedValue: cardViewModel)
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
           
            callFromSection
            
            profileImageAnimatedView
            
            userInfoSection
            
            interestTagsSection
            
            introductionSection
            
            actionButtonsSection
        }
    }
    /// 전화가 걸려온 사람을 표시하는 섹션
    private var callFromSection: some View {
        Text("\(cardViewModel.nickname) 님으로부터\n전화가 걸려왔어요")
            .multilineTextAlignment(.center)
            .font(.system(size: 24, weight: .bold))
    }
    
    private var profileImageAnimatedView: some View {
        ZStack {
            AsyncImage(url: cardViewModel.profileImages.first){ image in
                
                image
                    .resizable() // 1. 크기 조절 가능하게 설정 (필수!)
                    .scaledToFill() // 2. 프레임을 꽉 채우도록 비율 유지 (프로필 사진에 필수!)
                    .frame(width: 180, height: 180) // 3. 프레임 크기 지정
                    .clipShape(Circle()) // 4. 원형으로 자르기
                
            } placeholder: {
                Circle()
                    .frame(width: 180, height: 180) // 3. 프레임 크기 지정
            }
        }
        
        
    }
    /// 사용자 이름과 나이를 표시하는 뷰
    private var userInfoSection: some View {
        HStack {
                Text("\(cardViewModel.nickname)")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundStyle(.black)
                Text("\(cardViewModel.age)세")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundStyle(.gray)
            
            .font(.system(size: 24, weight: .bold, design: .default))
            .foregroundStyle(.white)
            
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
        }
        .padding(.horizontal)
    }
    
    /// 자기소개 텍스트를 표시하는 뷰
    private var introductionSection: some View {
        Text(cardViewModel.introduction)
            .foregroundStyle(.black)
            .font(.system(size: 18))
            .lineLimit(2)
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
                cardViewModel.chat()
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .foregroundStyle(Color.Siso.Red._60)
                    .overlay {
                        VStack {
                            Image("Phone-miss")
                                .resizable()
                                .renderingMode(.template) // 아이콘 색상 변경을 위해 추가
                                .foregroundStyle(.white)
                                .frame(width: 40, height: 40)
                            
                            Text("나중에 전화하기")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                    }
            }
            
            Spacer()
            
            Button {
                cardViewModel.call()
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: .infinity, maxHeight: 80)
                    .foregroundStyle(Color.Siso.Green._60)
                    .overlay {
                        VStack {
                            Image("phoneicon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            
                            Text("전화 연결")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                    }
            }
        }
        .frame(height: 80)
        .padding(.horizontal)
    }
}

#Preview {
    let cardViewModel = CardViewModel(
        nickname: "삼성전자회장이나야",
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
    MatchingCalledView(cardViewModel: cardViewModel)
}

