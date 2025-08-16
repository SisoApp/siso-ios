import SwiftUI

// --- 1. 데이터 모델 정의 (이전과 동일) ---

enum ListItemType {
    case user(Profile) // 삭제 예정
    case announcement(String)
    case advertisement(Ad)
}

struct Profile {
    let name, location, tags: String
}

struct Ad { let title, imageName: String }

struct ListItem: Identifiable {
    let id = UUID()
    let type: ListItemType
}


// --- 2. 메인 뷰 구현 ---

struct MatchingView: View { // 뷰 이름을 MatchingShortsView로 변경
    // 뷰가 아니라, 뷰를 그리기 위한 '데이터'의 배열
    @StateObject private var viewModel: MatchingViewModel = .sample
    
    var body: some View {
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
                }
            }
            .ignoresSafeArea()
        }
        
        
        
    }
}

@ViewBuilder
private func makeView(for cardViewModel: CardViewModel, geometry: GeometryProxy) -> some View {
    // 카드 뷰 생성 뷰빌더
    MatchingCardView(cardViewModel: cardViewModel )
        .frame(width: geometry.size.width, height: geometry.size.height)
}


// Preview Provider
struct MatchingShortsVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView()
    }
}
