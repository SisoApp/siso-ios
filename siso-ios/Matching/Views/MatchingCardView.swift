import SwiftUI
import designSystem
import model
import AVFoundation

struct MatchingCardView: View {
    
    // MARK: - Properties
    
    @StateObject var cardViewModel: CardViewModel
    @State private var isPlaying = false
    public var delegate: MatchingCoordinatorDelegate?
    
    
    // MARK: - Main Body
    
    var body: some View {
        
        VStack { // 컴포넌트 간 간격을 적절히 줍니다.
            Spacer()
            
            stateView
            
            profileImageView
            
            locationInfoSection
            
            userInfoSection
            
            voicePlayerSection
            
            interestTagsSection
            
            introductionSection
            
            actionButtonsSection
            
            Spacer()
        }
        .background {
            backgroundView
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
                .foregroundStyle(.white)
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
            .foregroundStyle(.white)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 위치 정보를 표시하는 뷰
    private var locationInfoSection: some View {
        HStack {
            Image("locationicon")
            Text(cardViewModel.location)
                .foregroundStyle(.white) // 배경이 어두울 것을 가정
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 음성 재생 관련 UI를 표시하는 뷰
    private var voicePlayerSection: some View {
        HStack {
            HStack {
                let systemName = cardViewModel.voiceSample != nil ? (isPlaying ? "pause.fill" : "play.fill") : "play.slash"
                
                Image(systemName: systemName)
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                
                WaveformView(count: 10, height: 14, isPlaying: $isPlaying)
                    .frame(width: 70)
                    .padding(.leading, 5)
            }
            .frame(width: 100, height: 18)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .opacity(0.3)
            )
            .onTapGesture {
                if cardViewModel.voiceSample != nil {
                    isPlaying.toggle()
                    // TODO: 실제 음성 재생/정지 로직 호출
                }
            }
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
                        .foregroundStyle(.white)
                    Text(interest)
                        .foregroundStyle(.white)
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
            .foregroundStyle(.white)
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
                    .foregroundStyle(Color.Siso.Blue._50)
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
    //MatchingCardView(cardViewModel: cardViewModel)
    
}
