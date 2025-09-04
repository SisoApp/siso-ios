import SwiftUI
import model
import network
public struct MatchingMainView: View {
    // MARK: - Properties
    @EnvironmentObject var appSettings: AppSettings
    @ObservedObject private var viewModel: MatchingViewModel
    @StateObject private var audioPlayer = AudioPlayerManager()
    public var delegate: MatchingCoordinatorDelegate?
    
    // 🔥 1. id 타입 변경: UUID? -> Int?
    // CardViewModel의 id 타입이 Int로 변경되었으므로, 스크롤 위치를 추적하는 상태 변수도 Int?로 변경합니다.
    @State private var currentCardId: Int?
    
    // MARK: - Initializer
    
    public init(viewModel: MatchingViewModel, delegate: MatchingCoordinatorDelegate?) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.delegate = delegate
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // 메인 카드 스크롤 뷰
            // 로딩 및 에러 처리를 위한 ZStack 구성은 이전 답변을 참고하여 추가할 수 있습니다.
            if viewModel.cards.isEmpty {
                Text ("조건에 맞는 상대가 없습니다.")
                    .font(.system(size: 25, weight: .bold))
            } else {
                GeometryReader { geometry in
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.cards) { cardViewModel in
                                makeView(for: cardViewModel, geometry: geometry)
                                // 🔥 2. id 프로퍼티 사용
                                // CardViewModel의 id는 이제 서버의 고유 userId(Int)입니다.
                                    .id(cardViewModel.id)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $currentCardId) // $currentCardId는 이제 Int? 타입과 바인딩됩니다.
                }
                .ignoresSafeArea()
            }
            
            // 프로필 작성 요구 뷰 (조건부 표시)
            if viewModel.isProfileWriteDemanded {
                ProfileDemandingView(matchingViewModel: viewModel, delegate: delegate)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // 종 모양 아이콘을 탭했을 때 실행될 코드
                    print("알림 버튼 탭!")
                    delegate?.pushMatching(.notification)
                }) {
                    // SF Symbols에서 "bell" 아이콘을 사용합니다.
                    Image(systemName: "bell")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.black)
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Text("둘러보기")
                    .font(.system(size: 24, weight: .bold))
            }
            
        })
        .onChange(of: currentCardId) { oldValue, newValue in
            guard let newID = newValue else { return }
            if let currentIndex = viewModel.cards.firstIndex(where: { $0.id == newID }) {
                let newWatchingCard = viewModel.cards[currentIndex]
                viewModel.nowWatching = newWatchingCard
                
                print("👀 Now Watching: \(newWatchingCard.nickname), Index: \(currentIndex)")
                
                // 무한 스크롤 로직 (비동기 호출은 Task로 감싸야 합니다)
                if currentIndex == viewModel.cards.count - 2 { 
                    Task {
                        await viewModel.fetchCards()
                    }
                }
            }
        }
        .onAppear {
            viewModel.injectDelegateToCards()
            currentCardId = viewModel.cards.first?.id
            
        }
        .task {
            await viewModel.fetchCards()
            await viewModel.fetchMyProfile { profile in
                appSettings.userProfile = profile
            }
            await viewModel.fetchMyImages { images in
                appSettings.profileImages = images
            }
            await viewModel.fetchMyVoice { voice in
                appSettings.voice = voice
            }
            await viewModel.fetchMyInterests { interests in
                appSettings.interests = interests
            }
        }
    }
    
    // MARK: - Helper Methods
    
    @ViewBuilder
    private func makeView(for cardViewModel: CardViewModel, geometry: GeometryProxy) -> some View {
        MatchingCardView(cardViewModel: cardViewModel, audioPlayer: self.audioPlayer)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
}
