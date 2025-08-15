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
                    .border(.green)
                }
                
                
            }
            .ignoresSafeArea()
            Button("ADD") {
                viewModel.cards.append(CardViewModel(nickname: "호날두",
                                                     age: 40,
                                                     isOnline: true,
                                                     interestTags: ["드리블", "슈팅", "헤딩"],
                                                     profileImages: [],
                                                     voiceSample: nil,
                                                     introduction: "안녕하세요 호날두입니다",
                                                     location: "서울 용산"
                                                    ))
            }
        }
        
        
        
    }
}

@ViewBuilder
private func makeView(for cardViewModel: CardViewModel, geometry: GeometryProxy) -> some View {
    // 카드 뷰 생성 뷰빌더
    MatchingCardView(cardViewModel: cardViewModel )
        .frame(width: geometry.size.width, height: geometry.size.height)
}

// DataDrivenCardView를 전체 화면용으로 변경 (배경을 채움)
struct DataDrivenCardFullPageView: View {
    let profile: Profile
    var body: some View {
        ZStack {
            // 배경색을 채움 (예: 그라데이션, 이미지 등)
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack {
                Spacer() // 상단 여백
                
                // 프로필 정보 (가운데 정렬)
                VStack(spacing: 10) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                    
                    Text(profile.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    Text(profile.location)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(profile.tags)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(Capsule().fill(Color.white.opacity(0.2)))
                }
                
                Spacer() // 하단 여백
                
                // 액션 버튼 (예시)
                HStack(spacing: 40) {
                    Button {
                        // 액션 1
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                    Button {
                        // 액션 2
                    } label: {
                        Image(systemName: "heart.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.pink)
                    }
                }
                .padding(.bottom, 50) // 하단 안전 영역 고려
            }
            .padding()
            
        }
    }
}

// 공지사항 뷰 (전체 화면용)
struct DataDrivenAnnouncementFullPageView: View {
    let text: String
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8) // 배경색
            
            VStack {
                Spacer()
                Image(systemName: "speaker.wave.2.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.brown)
                Text("공지사항")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                Text(text)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                Spacer()
            }
        }
    }
}



// 광고 뷰 (전체 화면용)
struct DataDrivenAdvertisementFullPageView: View {
    let ad: Ad
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.8), Color.teal.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            VStack {
                Spacer()
                Image(systemName: ad.imageName)
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                Text("AD")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .background(Capsule().fill(Color.black.opacity(0.5)))
                
                Text(ad.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button("자세히 보기") {
                    // 광고 클릭 액션
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Capsule().fill(Color.orange))
                .padding(.bottom, 50)
            }
        }
    }
}


// Preview Provider
struct MatchingShortsVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        //DataDrivenCardFullPageView(profile: .init(name: "이재용", location: "인천 남구", tags: "축구, 야구") )
        MatchingView()
    }
}
