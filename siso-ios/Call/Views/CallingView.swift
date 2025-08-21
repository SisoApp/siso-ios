//
//  CallingView.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI
import matching
import model // UserProfileServer 모델을 사용하기 위해 import
import designSystem // Color.Siso 등을 사용하기 위해 import

public struct CallingView: View {
   
    @StateObject var callViewModel: CallViewModel // @StateObject 또는 @ObservedObject
    
    // Coordinator와 통신이 필요하다면 delegate를 유지하고 init에서 주입받습니다.
    var delegate: CallCoordinatorDelegate?
    
    public init(callViewModel: CallViewModel, delegate: CallCoordinatorDelegate? = nil) {
        // StateObject는 뷰가 소유권을 가질 때 사용하므로 init에서 wrappedValue를 설정합니다.
        // 만약 상위 뷰에서 @StateObject로 생성된 ViewModel을 받는다면, 이 뷰는 @ObservedObject를 사용해야 합니다.
        self._callViewModel = .init(wrappedValue: callViewModel)
        self.delegate = delegate
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 20) {
            // 1. opponentProfile이 nil이 아닐 때만 프로필 정보를 표시합니다.
            if let profile = callViewModel.opponentProfile {
                
                // 2. 안전하게 얻은 profile 데이터를 각 뷰 '함수'에 파라미터로 전달합니다.
                profileImageView(profile: profile)
                
                userInfoSection(profile: profile)
                
                locationInfoSection(profile: profile)
                
                introductionSection(profile: profile)
                
                CountdownView() // 이 뷰는 이미 존재한다고 가정합니다.
                
                actionButtonsSection()
                
            } else {
                // 3. nil일 경우, 사용자에게 로딩 중임을 알려주는 UI를 표시합니다.
                Spacer()
                ProgressView()
                Text("상대방 정보를 불러오는 중...")
                Spacer()
            }
        }
        .padding(.vertical)
    }
    
    // MARK: - View Components (Functions)
    
    private func profileImageView(profile: UserProfileServer) -> some View {
        TabView {
            // profileImageUrls가 비어있을 경우를 대비
            if profile.profileImageUrls.isEmpty {
                placeholderImage
            } else {
                ForEach(profile.profileImageUrls, id: \.self) { urlString in
                    AsyncImage(url: URL(string: urlString)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                }
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .padding(.horizontal)
    }
    
    /// 이미지가 없을 때 표시할 플레이스홀더
    private var placeholderImage: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .overlay(
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            )
    }
    
    /// 사용자 이름과 나이를 표시하는 뷰
    private func userInfoSection(profile: UserProfileServer) -> some View {
        HStack {
            Text("\(profile.nickname),")
                .font(.system(size: 24, weight: .bold))
            
            Text("\(profile.age)세")
                .font(.system(size: 22, weight: .medium))
            
            Spacer()
        }
        .foregroundStyle(.black)
        .padding(.horizontal)
    }
    
    /// 위치 정보를 표시하는 뷰
    private func locationInfoSection(profile: UserProfileServer) -> some View {
        HStack {
            Image("locationicon_inverse") // 에셋 이름 확인 필요
            Text(profile.location) // UserProfileServer에 location이 옵셔널로 있다고 가정
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 자기소개 텍스트를 표시하는 뷰
    private func introductionSection(profile: UserProfileServer) -> some View {
        Text(profile.introduce)
            .foregroundStyle(.black)
            .font(.system(size: 16))
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
    }
    
    /// 하단 액션 버튼 (통화 종료, 음소거, 스피커) 뷰
    private func actionButtonsSection() -> some View {
        HStack(spacing: 16) {
            // 통화 종료 버튼
            Button {
                // Singleton 대신 주입받은 viewModel의 메서드를 호출합니다.
                //callViewModel.endCall()
            } label: {
                actionButtonContent(imageName: "quitcallicon", text: "통화 종료")
                    .frame(width: 80, height: 80)
                    .background(Color.Siso.Red._60)
                    .clipShape(Circle())
            }
            
            // 음소거 버튼
            Button {
                //callViewModel.toggleMute()
            } label: {
                // ViewModel의 상태에 따라 아이콘과 배경색이 바뀝니다.
                actionButtonContent(
                    imageName: callViewModel.isMuteMode ? "speaker.slash.fill" : "speaker.slash.fill", // 에셋 이름 확인 필요
                    text: callViewModel.isMuteMode ? "음소거 해제" : "음소거"
                )
                .frame(width: 80, height: 80)
                .background(callViewModel.isMuteMode ? Color.Siso.Blue._50 : Color.Siso.Gray._50)
                .clipShape(Circle())
            }
            
            // 스피커 버튼
            Button {
                callViewModel.isSpeakerMode.toggle()
            } label: {
                actionButtonContent(
                    imageName: "speakericon", // 에셋 이름 확인 필요
                    text: "스피커"
                )
                .frame(width: 80, height: 80)
                .background(callViewModel.isSpeakerMode ? Color.Siso.Blue._50 : Color.Siso.Gray._50)
                .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }
    
    /// 액션 버튼의 내부 UI를 재사용하기 위한 헬퍼 뷰
    private func actionButtonContent(imageName: String, text: String) -> some View {
        VStack(spacing: 4) {
            Image(imageName) // quitcallicon, speaker.slash.fill, speakericon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Text(text)
                .font(.system(size: 14, weight: .semibold))
        }
        .foregroundStyle(.white)
    }
}


// MARK: - Preview
#Preview {
    // 1. 샘플 UserProfileServer 데이터 생성
    // 2. 테스트용 CallViewModel 생성
    let previewViewModel = CallViewModel( oppnentProfile: UserProfileServer.sampleMessi)
    
    // 4. View에 ViewModel을 전달하여 프리뷰
    CallingView(callViewModel: previewViewModel)
}
