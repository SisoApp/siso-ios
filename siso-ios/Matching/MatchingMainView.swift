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
    @State var items: [ListItem] = [
        .init(type: .announcement("서버 점검이 9/1에 있습니다.")),
        .init(type: .user(Profile(name: "김철수", location: "서울 강남구", tags: "#코딩 #독서 #개발"))),
        .init(type: .advertisement(Ad(title: "요가 클래스 특별 할인! 건강한 라이프 시작!", imageName: "figure.yoga"))),
        .init(type: .user(Profile(name: "이영희", location: "부산 해운대구", tags: "#여행 #맛집탐방 #사진"))),
        .init(type: .user(Profile(name: "박지성", location: "런던", tags: "#축구 #운동 #은퇴"))),
        .init(type: .advertisement(Ad(title: "새로운 아이폰 15 출시! 사전 예약하세요.", imageName: "iphone.gen3"))),
        .init(type: .user(Profile(name: "최수정", location: "제주도", tags: "#바다 #카페 #힐링"))),
        .init(type: .announcement("앱 업데이트가 곧 진행됩니다. 새로운 기능 기대해주세요!"))
    ]
    
    var body: some View {
        // 동적 데이터 처리를 위해서 LazyVStack으로 처리
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    LazyVStack(spacing: 0){
                        ForEach(items) { item in
                           makeView(for: item, geometry: geometry)
                        }
                    }
                   
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .border(.green)
            }
            
            Button("ADD") {
                items.append(ListItem.init(type: .user(Profile.init(name: "호날두", location: "마데이라섬", tags: "발롱도르 축신"))))
            }
        }
        .ignoresSafeArea()
    }
}

@ViewBuilder
private func makeView(for item: ListItem, geometry: GeometryProxy) -> some View {
    Group {
        switch item.type {
                    case .user(let profile):
                        DataDrivenCardFullPageView(profile: profile)
                    case .announcement(let announcement):
                        // 다른 뷰들도 모두 전체 화면으로 만들어야 일관성이 있습니다.
                        DataDrivenAnnouncementFullPageView(text: announcement)
                    case .advertisement(let ad):
                        DataDrivenAdvertisementFullPageView(ad: ad)
                    }
    }
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
