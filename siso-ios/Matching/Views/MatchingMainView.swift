import SwiftUI


public struct MatchingMainView: View {
    @ObservedObject private var viewModel: MatchingViewModel
    @StateObject private var audioPlayer = AudioPlayerManager()
    public var delegate: MatchingCoordinatorDelegate?
    
    @State var currentCardId: UUID?
    
    public init(viewModel: MatchingViewModel, delegate: MatchingCoordinatorDelegate?) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.delegate = delegate
    }
    
    public var body: some View {
        // 동적 데이터 처리를 위해서 LazyVStack으로 처리
        ZStack {
            GeometryReader { geometry in
                VStack {
                    ScrollView {
                        LazyVStack(spacing: 0){
                            ForEach(viewModel.cards) { item in
                                makeView(for: item, geometry: geometry)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.paging)
                    .scrollPosition(id: $currentCardId)
                }
            }
            .ignoresSafeArea()
            if viewModel.isProfileWriteDemanded {
                ProfileDemandingView(matchingViewModel: viewModel, delegate: delegate)
            }
        }
        .onChange(of: currentCardId) { oldValue, newValue in
            guard let newID = newValue else { return }
            
            // 변경된 ID에 해당하는 카드를 viewModel에서 찾습니다.
            if let newWatchingCard = viewModel.cards.first(where: { $0.uuid == newID }) {
                // viewModel의 nowWatching 프로퍼티를 업데이트합니다.
                viewModel.nowWatching = newWatchingCard
                print("👀 Now Watching: \(newWatchingCard.nickname)")
            }
        }
        .onAppear(){
            viewModel.injectDelegateToCards()
        }
        
        
    }
}


@ViewBuilder
private func makeView(for cardViewModel: CardViewModel, geometry: GeometryProxy) -> some View {
    // 카드 뷰 생성 뷰빌더
    MatchingCardView(cardViewModel: cardViewModel, audioPlayer: AudioPlayerManager() )
        .frame(width: geometry.size.width, height: geometry.size.height)
}


// Preview Provider
struct MatchingShortsVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingMainView(viewModel: MatchingViewModel( cards: []), delegate: nil)
    }
}
