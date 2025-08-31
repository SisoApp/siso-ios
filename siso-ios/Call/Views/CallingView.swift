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
    
    @StateObject var callViewModel: CallViewModel
    
    // Coordinator와 통신이 필요하다면 delegate를 유지하고 init에서 주입받습니다.
    var delegate: CallCoordinatorDelegate?
    
    public init(inCallViewModel: CallViewModel, delegate: CallCoordinatorDelegate? = nil) {
        // StateObject는 뷰가 소유권을 가질 때 사용하므로 init에서 wrappedValue를 설정합니다.
        // 만약 상위 뷰에서 @StateObject로 생성된 ViewModel을 받는다면, 이 뷰는 @ObservedObject를 사용해야 합니다.
        self._callViewModel = .init(wrappedValue: inCallViewModel)
        self.delegate = delegate
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack {
            
            HStack {
                profileImageView(profile: callViewModel.opponentCallInfo)
                VStack(alignment: .leading, spacing: 0){
                    Text("\(callViewModel.opponentCallInfo.nickname)")
                        .font(.system(size: 24, weight: .bold))
                    HStack {
                        Text("\(callViewModel.opponentCallInfo.age)세")
                            .font(.system(size: 22, weight: .medium))
                        locationInfoSection(profile: callViewModel.opponentCallInfo)
                    }
                    
                }
            }
            
            Spacer()
            
            VStack {
                Text("남은시간")
                
                Text(callViewModel.remainTime)
                    .font(.system(size: 32, weight: .bold))
                
                Button {
                    // 통화 시간 연장 (결제 필요함, 아직 결제 기능 없으므로 무료 연장)
                    callViewModel.remainingSeconds += 60.0
                } label: {
                    
                    Text("통화 연장하기")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        .foregroundStyle(.black)
                        .background
                    {
                        // 삼항 연산자를 사용한 버전
                        callViewModel.remainingSeconds < 60.0 ?
                        
                        // 참일 때 (60초 미만): 배경 채우기
                        AnyView(RoundedRectangle(cornerRadius: 30)
                            .fill(Color.Siso.Primary._40))
                        :
                        // 거짓일 때 (60초 이상): 흰 배경 + 테두리
                        AnyView(RoundedRectangle(cornerRadius: 30)
                            .fill(Color.white) // 배경을 흰색으로 채우고
                            .overlay( // 그 위에 테두리를 겹쳐 그린다
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.Siso.Primary._40, lineWidth: 2)
                                    )
                        )
                    }
                    
                }
            }
            
            Spacer()
            commonInterestView(profile: callViewModel.opponentCallInfo)
            
            actionButtonsSection()
        }
        .padding(.vertical)
    }
    
    // MARK: - View Components (Functions)
    @ViewBuilder
    private func profileImageView(profile: CallInfoDto) -> some View {
        // profileImageUrls가 비어있을 경우를 대비
        if profile.profileImageUrl == nil {
            placeholderImage
        } else {
            let urlString = profile.profileImageUrl!
            AsyncImage(url: URL(string: urlString)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.circle)
                    .frame(width: 100 ,height: 100)
            } placeholder: {
                
                ZStack{
                    Rectangle()
                        .foregroundStyle(.white)
                    ProgressView()
                }
                .frame(width: 100, height: 100)
                
            }
        }
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
    private func userInfoSection(profile: CallInfoDto) -> some View {
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
    private func locationInfoSection(profile: CallInfoDto) -> some View {
        HStack {
            Image("locationicon_inverse") // 에셋 이름 확인 필요
            Text(profile.location ?? "비공개") // UserProfileServer에 location이 옵셔널로 있다고 가정
                .foregroundStyle(.secondary)
                .lineLimit(1)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// 자기소개 텍스트를 표시하는 뷰
//    private func introductionSection(profile: CallInfoDto) -> some View {
//        Text(profile.introduce)
//            .foregroundStyle(.black)
//            .font(.system(size: 16))
//            .lineLimit(2)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.horizontal)
//    }
    
    private func commonInterestView(profile: CallInfoDto) -> some View {
        HStack {
            Text("공통 관심사")
                .font(.system(size: 18, weight: .medium))
                .padding(5)
                .overlay( // 그 위에 테두리를 겹쳐 그린다
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.Siso.Primary._40, lineWidth: 2)
                        )
                .frame(width: 100)
               
            ForEach(profile.interests, id: \.self) { interest in
                Text("#\(interest)")
                    .lineLimit(1)
                    .fixedSize()
            }
        }
        .padding(.horizontal)
    }
    
    /// 하단 액션 버튼 (통화 종료, 음소거, 스피커) 뷰
    private func actionButtonsSection() -> some View {
        HStack(spacing: 16) {
            // 통화 종료 버튼
            Button {
                // Singleton 대신 주입받은 viewModel의 메서드를 호출합니다.
                callViewModel.endCall()
            } label: {
                
                actionButtonContent(imageName: "endcall", text: "통화 종료", condition: false)
                    .frame(width: 104, height: 96)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            
            // 음소거 버튼
            Button {
                callViewModel.isMuteMode.toggle()
                
            } label: {
                // ViewModel의 상태에 따라 아이콘과 배경색이 바뀝니다.
                actionButtonContent(
                    imageName: callViewModel.isMuteMode ? "Volume-off 1" : "Volume-off", // 에셋 이름 확인 필요
                    text: callViewModel.isMuteMode ? "음소거" : "음소거",
                    condition: callViewModel.isMuteMode
                )
                .frame(width: 104, height: 96)
                .background(callViewModel.isMuteMode ? Color.Siso.Gray._50 : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            
            // 스피커 버튼
            Button {
                callViewModel.isSpeakerMode.toggle()
            } label: {
                actionButtonContent(
                    imageName: callViewModel.isSpeakerMode ? "Volume-up1" :"Volume-up",
                    text: "스피커",
                    condition: callViewModel.isSpeakerMode
                )
                .frame(width: 104, height: 96)
                .background(callViewModel.isSpeakerMode ? Color.Siso.Blue._50 : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .padding(.horizontal)
    }
    
    /// 액션 버튼의 내부 UI를 재사용하기 위한 헬퍼 뷰
    private func actionButtonContent(imageName: String, text: String, condition: Bool) -> some View {
        VStack(spacing: 4) {
            Image(imageName) // quitcallicon, speaker.slash.fill, speakericon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Text(text)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(condition ? .white : .black)
        }
    }
}


