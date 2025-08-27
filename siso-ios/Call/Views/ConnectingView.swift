//
//  ConnectingView.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import SwiftUI
import matching
import model // UserProfileServer 모델을 사용하기 위해 import
import designSystem // Color.Siso 등을 사용하기 위해 import

/// 상대방과 전화 연결을 시도하는 중임을 보여주는 뷰입니다.
public struct ConnectingView: View {
    var opponentProfile: UserProfileServer
    var delegate: CallCoordinatorDelegate?
    
    public init(opponentProfile: UserProfileServer, delegate: CallCoordinatorDelegate? = nil) {
        self.opponentProfile = opponentProfile
        self.delegate = delegate
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // 1. opponentProfile이 nil일 경우를 대비해 기본값("상대방")을 제공합니다.
            Text("\(opponentProfile.nickname) 님과\n연결중이에요")
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
                .padding()
            
            // 이 뷰는 이미 존재한다고 가정합니다.
            CallingWaveformView(count: 15, height: 100, isplaying: true)
                .frame(width: 300)
                .padding()
            
            // TabView를 사용하여 대화 팁을 보여줍니다.
            TabView {
                talkTipsSection
            }
            .tabViewStyle(.page)
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .frame(height: 150) // 콘텐츠에 맞게 높이 조절
            
            // 취소 버튼 추가 (사용자 경험을 위해 중요)
            Button {
                // ✨ 전화를 거는 것을 취소하는 것도 결국 'endCall'
                CallManager.shared.endCall(reason: .cancelled)
                delegate?.popToRoot()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.Siso.Gray._5)
                        .stroke(Color.Siso.Gray._30, lineWidth: 1)
                    VStack {
                        Image("endcall")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text("전화 종료")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                    }
                }
            }
            .padding()
            
            Spacer()
        }
        .onAppear(){
            // TODO: 연결 시도 로직 시작 (예: 타이머, 실제 연결 요청 등)
        }
    }
    
    // MARK: - Subviews
    @ViewBuilder
    private func profileImageView(profile: UserProfileServer) -> some View {
        // profileImageUrls가 비어있을 경우를 대비
        if profile.profileImageUrls.isEmpty {
            placeholderImage
        } else {
            let urlString = profile.profileImageUrls.first!
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
    
    // 2. 팁 내용을 배열로 관리하여 유지보수를 쉽게 합니다.
    private let tips = [
        "처음엔\n가볍고 따듯한 이야기로\n시작해보세요.",
        "서로 다른 점보다는 공감할 수\n있는 이야기를 먼저 나눠요.",
        "예의있는 대화를 나눌수록\n긍정적인 매칭결과를 보여요.",
        "취미, 관심사 등으로\n대화의 물꼬를 터봐요."
    ]
    
    private var talkTipsSection: some View {
        // ForEach를 사용하여 팁 배열을 순회하며 Text 뷰를 생성합니다.
        ForEach(tips, id: \.self) { tip in
            Text(tip)
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._70)
                .padding(.horizontal)
        }
    }
}


// MARK: - Preview
//
//#Preview {
//    // 4. 완성된 ViewModel을 View에 주입하여 프리뷰를 실행합니다.
//    ConnectingView(opponentProfile: UserProfileServer.sampleMessi)
//}
