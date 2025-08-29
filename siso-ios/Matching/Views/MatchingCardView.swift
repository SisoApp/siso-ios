import SwiftUI
import designSystem
import model
import AVFoundation

public struct MatchingCardView: View {
    
    // MARK: - Properties
    
    @ObservedObject var cardViewModel: CardViewModel
    @ObservedObject var audioPlayer: AudioPlayerManager
    
    public init(cardViewModel: CardViewModel, audioPlayer: AudioPlayerManager) {
        self._cardViewModel = .init(wrappedValue: cardViewModel)
        self._audioPlayer = .init(wrappedValue: audioPlayer)
    }
    
    // MARK: - Main Body
    
    public var body: some View {
        
        VStack { // 컴포넌트 간 간격을 적절히 줍니다.
            Spacer()
            
            stateView
            
            profileImageView
            
            locationInfoSection
            
            HStack{
                userInfoSection
                    .fixedSize()
                Spacer()
                voicePlayerSection
                    
            }
            .padding(.horizontal)
            
            
            interestTagsSection
            
            introductionSection
          
            actionButtonsSection
            
            Spacer()
         
        }
        
    }
    
    // MARK: - Subviews (UI Components)
    @ViewBuilder
    private var backgroundView: some View {
        if let firstImgUrl = cardViewModel.profileImages.first {
            
            AsyncImage(url: firstImgUrl) { image in
                // '결과' 1: 성공 시 SwiftUI의 Image 뷰를 받음
                image
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 60)
                    .overlay {
                        Color.black
                            .opacity(0.6)
                    } // 이미지가 프레임에 맞게 조절되도록 설정
            } placeholder: {
                // '결과' 2: 로딩 중 SwiftUI의 View를 보여줌
                Color.black
                    .blur(radius: 60)
                    .overlay {
                        Color.black
                            .opacity(0.6)
                    }
            }
            
        }
    }
    
    
    private var stateView: some View {
        HStack {
            makeUserStateView // 괄호 없이 접근
            Spacer()
        }
        .padding(.horizontal)
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
    
    @ViewBuilder
    private var makeUserStateView: some View {
        let isOnline = cardViewModel.isOnline
        let circleColor: Color = isOnline ? .green : .gray
        let statusText: String = isOnline ? "온라인" : "오프라인"
        
        HStack {
            Circle()
                .fill(circleColor)
                .frame(width: 10, height: 10)
            
            Text(statusText)
                .foregroundStyle(.black)
        }
    }
    
    /// 사용자 이름과 나이를 표시하는 뷰
    private var userInfoSection: some View {
        HStack {
            Group {
                Text("\(cardViewModel.nickname),")
                Text("\(cardViewModel.age)세")
            }
            .font(.system(size: 24, weight: .bold, design: .default))
            .foregroundStyle(.black)
            
            Spacer()
        }
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
    
    /// 음성 재생 관련 UI를 표시하는 뷰
    private var voicePlayerSection: some View {
        let isCurrentlyPlayingThisCard = audioPlayer.isPlaying && audioPlayer.currentlyPlayingURL == cardViewModel.voiceSample
        return HStack {
            HStack(spacing: -15) {
                let systemName = cardViewModel.voiceSample != nil ? (audioPlayer.isPlaying ? "pause.fill" : "play.fill") : "play.slash"
                
                Image(systemName: systemName)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                
                WaveformView(count: 6, height: 20, isPlaying: .constant(isCurrentlyPlayingThisCard))
                    .frame(width: 70)
                    .padding(.leading, 5)
            }
            .frame(width: 76, height: 44)
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.Siso.Gray._70)
            )
            .onTapGesture {
                guard let voiceURL = cardViewModel.voiceSample else { return }
                
                // ✨ 6. 탭 제스처 로직을 수정합니다.
                if isCurrentlyPlayingThisCard {
                    // 현재 이 카드의 오디오가 재생 중이면 -> 일시정지
                    audioPlayer.pause()
                } else {
                    audioPlayer.play(from: voiceURL)
                }
            }
        }
        
    }
    
    /// 관심사 태그들을 표시하는 뷰
    private var interestTagsSection: some View {
        HStack {
            ForEach(cardViewModel.interestTags.prefix(3), id: \.self) { interest in // 태그가 너무 많으면 잘릴 수 있으므로 prefix 사용 고려
                HStack(spacing: 2) {
                    Text("#")
                        .foregroundStyle(.black)
                    Text(interest)
                        .foregroundStyle(.black)
                }
                .font(.system(size: 18))
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
                cardViewModel.chat()
            } label: {
                RoundedRectangle(cornerRadius: 24)
                    .frame(maxWidth: 80, maxHeight: 80)
                    .foregroundStyle(Color.Siso.Gray._40)
                    .overlay {
                        Image("envelopeicon")
                            .resizable()
                            .renderingMode(.template) // 아이콘 색상 변경을 위해 추가
                            .foregroundStyle(.white)
                            .frame(width: 40, height: 40)
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
                        Image(systemName: "phone.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.white)
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
        baseProfile: MatchingProfile.sampleMessi,
        nickname: "삼성전자회장이나야",
        age: 58,
        isOnline: true,
        interestTags: ["여행✈️", "사진", "카페투어"],
        profileImages: [
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane1/600/400")!,
            URL(string: "https://picsum.photos/seed/jane2/400/600")!,
            URL(string: "https://picsum.photos/seed/jane3/400/600")!
        ],
        voiceSample: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
        introduction: "안녕하세요! 좋은 인연을 찾고 있어요. 함께 맛있는 거 먹으러 다녀요. SwiftUI는 재밌지만 가끔은 어렵네요. 그래도 열심히 공부하고 있습니다. 같이 코딩하실 분도 환영!",
        location: "인천 미추홀구"
    )
    MatchingCardView(cardViewModel: cardViewModel, audioPlayer: AudioPlayerManager())
    
}
