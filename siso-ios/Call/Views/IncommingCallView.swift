//
//  CalledView.swift
//  matching
//
//  Created by jdios on 8/15/25.
//

import SwiftUI
import designSystem
import matching
import model


public struct IncommingCallView: View {
    // ViewModel 대신, 필요한 데이터 모델을 직접 받습니다.
    let callInfo: IncomingCallInfo
    var delegate: CallCoordinatorDelegate
    
    public init(callInfo: IncomingCallInfo, delegate: CallCoordinatorDelegate) {
        self.callInfo = callInfo
        self.delegate = delegate
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 24) {
            // 이제 옵셔널이 아닌 `callInfo`에서 직접 데이터를 사용합니다.
            let profile = callInfo.opponentProfile
            
            callFromSection(profile: profile)
            profileImageAnimatedView(profile: profile)
            userInfoSection(profile: profile)
            interestTagsSection(profile: profile)
            introductionSection(profile: profile)
            actionButtonsSection() // profile 전달 불필요
        }
        .padding(.vertical)
    }
    
    // MARK: - View Components (Functions)
    
    /// 전화가 걸려온 사람을 표시하는 섹션
    private func callFromSection(profile: MatchingProfile) -> some View {
        Text("\(profile.nickname) 님으로부터\n전화가 걸려왔어요")
            .multilineTextAlignment(.center)
            .font(.system(size: 24, weight: .bold))
            .padding(.horizontal)
    }
    
    /// 프로필 이미지를 표시하는 뷰
    private func profileImageAnimatedView(profile: MatchingProfile) -> some View {
        // profileImageUrls 배열의 첫 번째 이미지를 사용하되, nil-coalescing으로 안전하게 처리합니다.
        // URL(string:) 생성자도 옵셔널을 반환하므로 if let으로 처리하는 것이 더 안전합니다.
        let imageUrl = URL(string: profile.imageUrls.first ?? "")
        
        return AsyncImage(url: imageUrl) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            // 이미지가 로드되기 전이나 URL이 유효하지 않을 때 표시될 뷰
            Circle()
                .fill(Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
        }
        .frame(width: 180, height: 180)
        .clipShape(Circle())
        .shadow(radius: 5) // 약간의 그림자 효과 추가
    }
    
    /// 사용자 이름과 나이를 표시하는 뷰
    private func userInfoSection(profile: MatchingProfile) -> some View {
        HStack(spacing: 8) {
            Text(profile.nickname)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(.black)
            
            Text("\(profile.age)세")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(.gray)
        }
    }
    
    /// 관심사 태그들을 표시하는 뷰
    private func interestTagsSection(profile: MatchingProfile) -> some View {
        // 태그가 많을 경우를 대비해 스크롤 뷰를 사용하고, 최대 5개까지만 표시
        HStack {
            ForEach(profile.interests.prefix(5), id: \.self) { interest in
                Text("#\(interest)")
                    .font(.system(size: 16, weight: .medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
    }
    
    /// 자기소개 텍스트를 표시하는 뷰
    private func introductionSection(profile: MatchingProfile) -> some View {
        Text(profile.introduce)
            .foregroundStyle(.secondary) // 본문 텍스트에 적합한 색상
            .font(.system(size: 16))
            .lineLimit(2)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 30) // 좌우 여백을 더 주어 가독성 향상
    }
    
    
    /// 하단 액션 버튼 (거절, 수락) 뷰
    private func actionButtonsSection() -> some View {
        HStack(spacing: 20) {
            // "나중에 전화하기" (거절) 버튼
            Button {
                CallManager.shared.endCall(reason: .cancelled)
            } label: {
                VStack(spacing: 4) {
                    Image("Phone-miss") // 에셋 이름 확인 필요
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                    
                    Text("나중에 전화하기")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color.Siso.Red._60)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
            
            // "전화 연결" (수락) 버튼
            Button {
                // TODO: 전화 수락 로직 연결 (예: delegate?.acceptCall(channelName: ...))
                CallManager.shared.acceptCall()
            } label: {
                VStack(spacing: 4) {
                    Image("phoneicon") // 에셋 이름 확인 필요
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)
                    
                    Text("전화 연결")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 80)
                .background(Color.Siso.Green._60)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview

