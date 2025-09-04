import SwiftUI
import designSystem
import model
import AVFoundation

public struct MatchingCardView: View {
    
    // MARK: - Properties
    
    @ObservedObject var cardViewModel: CardViewModel
    @ObservedObject var audioPlayer: AudioPlayerManager
    @State private var showChatNotice: Bool = false
    
    public init(cardViewModel: CardViewModel, audioPlayer: AudioPlayerManager) {
        self._cardViewModel = .init(wrappedValue: cardViewModel)
        self._audioPlayer = .init(wrappedValue: audioPlayer)
    }
    
    // MARK: - Main Body
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Spacer()
                stateView
                profileImageView
                locationInfoSection
                HStack {
                    userInfoSection
                        .fixedSize()
                    Spacer()
                    voicePlayerSection
                }
                .padding(.horizontal)
                
                interestTagsSection
                
                introductionSection
                Spacer()
                
                actionButtonsSection
                Spacer()
            }
            if showChatNotice {
                chatNoticeBoxView
                    .padding(.bottom, 120) // 하단 버튼 위로 위치 조정
                    .transition(.opacity.combined(with: .move(edge: .bottom))) // 나타나고 사라질 때 애니메이션
                    .onAppear {
                        // 뷰가 나타난 후 3초 뒤에 사라지도록 타이머 설정
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            // 애니메이션과 함께 상태 변경
                            withAnimation {
                                showChatNotice = false
                            }
                        }
                    }
            }
        }
        // background는 VStack의 background로 설정하는 것이 더 일반적입니다.
        .background(.white)
        
       
        
    }
    
    private var stateView: some View {
        HStack {
            makeUserStateView
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 프로필 이미지들을 보여주는 TabView
    private var profileImageView: some View {
        TabView {
            // 프로필 이미지가 하나도 없는 경우
            if cardViewModel.profileImageURLs.isEmpty {
                placeholderImage
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // 프로필 이미지가 있는 경우, 각 URL에 대해 이미지 뷰를 생성
                ForEach(cardViewModel.profileImageURLs, id: \.self) { url in
                    
                    // AsyncImage의 phase를 사용하여 로딩 상태를 세밀하게 제어
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            // 로딩 중일 때 ProgressView를 포함한 플레이스홀더 표시
                            loadingPlaceholder
                            
                        case .success(let image):
                            // 로딩 성공 시 이미지 표시
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit) // fill로 꽉 채우기
                            
                        case .failure(let error):
                            // 로딩 실패 시 에러 아이콘을 포함한 플레이스홀더 표시
                            failurePlaceholder(error: error, url: url)
                            
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 242)
        .background(Color.gray.opacity(0.1)) // 이미지 뒤에 연한 배경색 추가
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    // @ViewBuilder
    private var makeUserStateView: some View {
        
        
        let status = cardViewModel.presenceStatus
        let circleColor: Color
        let statusText: String
        
        switch status {
        case .inCall:
            circleColor = .yellow
            statusText = "통화중"
        case .offline:
            circleColor = .gray
            statusText = "오프라인"
        case .online:
            circleColor = .green
            statusText = "온라인"
        }
        
        return HStack {
            Circle()
                .fill(circleColor)
                .frame(width: 10, height: 10)
            
            // 폰트 색상을 배경에 맞게 수정 (예: white)
            Text(statusText)
                .foregroundStyle(.black)
        }
    }
    
    private var userInfoSection: some View {
        HStack {
            // 🔥 변경: viewModel의 계산 프로퍼티 사용
            Text("\(cardViewModel.nickname),")
            Text("\(cardViewModel.age)세")
        }
        .font(.system(size: 24, weight: .bold))
        .foregroundStyle(.black) // 배경이 어두우므로 white로 변경
    }
    
    private var locationInfoSection: some View {
        HStack {
            Image("locationicon_inverse") // 아이콘 이름 확인 필요
            // 🔥 변경: viewModel의 계산 프로퍼티 사용
            Text(cardViewModel.location)
                .foregroundStyle(.black) // 배경에 맞게 white로 변경
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var voicePlayerSection: some View {
        // 🔥 변경: viewModel의 계산 프로퍼티 사용
        let isCurrentlyPlayingThisCard = audioPlayer.isPlaying && audioPlayer.currentlyPlayingURL == cardViewModel.voiceSampleURL
        
        return HStack {
            HStack(spacing: -15) {
                // 🔥 변경: viewModel의 계산 프로퍼티 사용
                let systemName = cardViewModel.voiceSampleURL != nil ? (isCurrentlyPlayingThisCard ? "pause.fill" : "play.fill") : "play.slash"
                
                Image(systemName: systemName)
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                
                WaveformView(count: 6, height: 20, isPlaying: .constant(isCurrentlyPlayingThisCard))
                    .frame(width: 70)
                    .padding(.leading, 5)
            }
            .frame(width: 76, height: 44)
            .padding(.horizontal, 5)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.Siso.Gray._70))
            .onTapGesture {
                // 🔥 변경: viewModel의 계산 프로퍼티 사용
                guard let voiceURL = cardViewModel.voiceSampleURL else { return }
                
                if isCurrentlyPlayingThisCard {
                    audioPlayer.pause()
                } else {
                    audioPlayer.play(from: voiceURL)
                }
            }
        }
    }
    
    private var interestTagsSection: some View {
        HStack(spacing: 8) {
            // 🔥 변경: viewModel의 계산 프로퍼티 사용
            ForEach(cardViewModel.interestTags, id: \.self) { interest in
                Text(interest.description)
                    .font(.system(size: 16))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var introductionSection: some View {
        // 🔥 변경: viewModel의 계산 프로퍼티 사용
        Text(cardViewModel.introduction)
            .foregroundStyle(Color.black.opacity(0.9))
            .font(.system(size: 16))
            .lineLimit(2) // 2줄로 제한하고, 더보기 기능을 넣을 수 있음
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .onTapGesture {
                print("show all text")
            }
    }
    
    
    /// 하단 액션 버튼 (메시지, 통화) 뷰
    private var actionButtonsSection: some View {
        HStack {
            Button {
                // 여기 버튼 동작
                print("chat")
                showChatNotice = true
                
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
    
    private var chatNoticeBoxView: some View {
        Text("통화 및 상호 동의 이후 대화가 가능합니다.")
            .font(.system(size: 20, weight: .semibold))
            .foregroundColor(Color.Siso.Gray._0)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(Color.Siso.Gray._90.opacity(0.7))
                
            }
            .frame(maxWidth: .infinity)
           
    }
    
    /// 이미지가 아예 없을 때 보여줄 기본 플레이스홀더
    private var placeholderImage: some View {
        // 여기에 브랜드 로고나 기본 이미지를 넣을 수 있습니다.
        Image("seeting_LOGO")
            .resizable()
            .scaledToFit()
            .padding(40) // 로고가 너무 꽉 차지 않도록 여백 추가
    }
    
    /// 이미지 로딩 중에 보여줄 플레이스홀더
    private var loadingPlaceholder: some View {
        ZStack {
            Color.clear // 배경색을 투명하게 하여 .background modifier의 색이 보이도록 함
            ProgressView()
        }
    }
    
    /// 이미지 로딩 실패 시 보여줄 플레이스홀더
    private func failurePlaceholder(error: Error, url: URL) -> some View {
        ZStack {
            Color.clear
            Image(systemName: "photo.on.rectangle.angled")
                .font(.largeTitle)
                .foregroundColor(.gray.opacity(0.5))
        }
        .onAppear {
            // 이제 이 스코프에서는 error와 url 변수를 정상적으로 사용할 수 있습니다.
            print("🖼️ [AsyncImage] Failed to load image from \(url).")
            print("🖼️ [AsyncImage] Error: \(error.localizedDescription)")
        }
    }
    
}


