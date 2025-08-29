import SwiftUI

public struct MatchingMainView: View {
    // MARK: - Properties
    
    // 외부에서 주입받는 ViewModel. @ObservedObject는 뷰가 소유하지 않음을 의미합니다.
    @ObservedObject private var viewModel: MatchingViewModel
    
    // 이 뷰가 직접 소유하고 생명주기를 관리하는 오디오 플레이어.
    @StateObject private var audioPlayer = AudioPlayerManager()
    
    // Coordinator와 통신하기 위한 Delegate
    public var delegate: MatchingCoordinatorDelegate?
    
    // ScrollView의 현재 위치에 있는 카드의 ID를 저장하는 상태 변수
    @State private var currentCardId: UUID?
    
    // MARK: - Initializer
    
    public init(viewModel: MatchingViewModel, delegate: MatchingCoordinatorDelegate?) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.delegate = delegate
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // 배경 뷰 (필요하다면 추가)
            // Color.gray.opacity(0.1).ignoresSafeArea()
            
            GeometryReader { geometry in
                ScrollView(.vertical) { // 스크롤 방향 명시
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.cards) { cardViewModel in
                            // 각 카드 뷰에 고유 ID를 부여하는 것이 .scrollPosition의 핵심입니다.
                            makeView(for: cardViewModel, geometry: geometry)
                                .id(cardViewModel.uuid)
                        }
                    }
                    // LazyVStack 전체가 스크롤 타겟들의 레이아웃임을 알려줍니다.
                    .scrollTargetLayout()
                }
                // 스크롤 동작을 페이지 단위로 설정합니다.
                .scrollTargetBehavior(.paging)
                // ScrollView의 현재 위치(ID)를 currentCardId 변수와 양방향으로 동기화합니다.
                .scrollPosition(id: $currentCardId)
            }
            .ignoresSafeArea()
            
            // 프로필 작성 요구 뷰 (조건부 표시)
            if viewModel.isProfileWriteDemanded {
                ProfileDemandingView(matchingViewModel: viewModel, delegate: delegate)
            }
        }
        .onChange(of: currentCardId) { oldValue, newValue in
            // currentCardId가 변경될 때마다 이 블록이 실행됩니다.
            guard let newID = newValue else { return }
            
            // 변경된 ID를 사용하여 현재 카드의 '인덱스'를 찾습니다.
            if let currentIndex = viewModel.cards.firstIndex(where: { $0.uuid == newID }) {
                
                // 찾은 인덱스를 사용하여 현재 카드 뷰모델을 가져옵니다.
                let newWatchingCard = viewModel.cards[currentIndex]
                
                // ViewModel의 nowWatching 프로퍼티(현재 보고 있는 카드)를 업데이트합니다.
                viewModel.nowWatching = newWatchingCard
                
                // 디버깅을 위해 현재 카드 정보와 인덱스를 출력합니다.
                print("👀 Now Watching: \(newWatchingCard.nickname), Index: \(currentIndex)")
                
                // TODO: 무한 스크롤링 제시
                if Double(currentIndex / viewModel.cards.count) > 0.8 {
                    viewModel.fetchCards()
                }
            }
        }
        .onAppear {
            // 뷰가 처음 나타날 때, 모든 카드에 delegate를 주입합니다.
            viewModel.injectDelegateToCards()
            
            // 뷰가 나타나는 즉시 첫 번째 카드를 현재 위치로 설정하여
            // 초기 상태를 명확히 하고, .onChange가 바로 트리거되도록 합니다.
            currentCardId = viewModel.cards.first?.uuid
        }
    }
    
    // MARK: - Helper Methods
    
    @ViewBuilder
    private func makeView(for cardViewModel: CardViewModel, geometry: GeometryProxy) -> some View {
        // 카드 뷰를 생성하는 헬퍼 메서드
        // 참고: AudioPlayerManager를 여기서 새로 생성하면 카드마다 다른 플레이어가 생깁니다.
        // 모든 카드가 하나의 오디오 플레이어를 공유하려면 @StateObject로 선언된 audioPlayer를 전달해야 합니다.
        MatchingCardView(cardViewModel: cardViewModel, audioPlayer: self.audioPlayer)
            .frame(width: geometry.size.width, height: geometry.size.height)
    }
}
