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
            actionButtonsSection
            Spacer()
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
    
    private var profileImageView: some View {
        TabView {
            // profileImageURLs가 비어있는 경우를 대비
            if cardViewModel.profileImageURLs.isEmpty {
                // 여기에 로고 이미지를 표시하는 뷰를 직접 넣습니다.
                Image("seeting_LOGO") // Assets에 있는 로고 이미지 이름
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.gray.opacity(0.2)) // 배경색 추가
            } else {
                ForEach(cardViewModel.profileImageURLs, id: \.self) { url in
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        // 이미지 로딩 중일 때 보여줄 뷰
                        ZStack {
                            Color.gray.opacity(0.2)
                            
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 32, maxHeight: 32)
                                .foregroundStyle(Color.Siso.Gray._40)
                        }
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 242)
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
                    .foregroundStyle(.black)
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


