// ReceivingCallView.swift

import SwiftUI
import model

/// 전화 수신 화면을 나타내는 임시 뷰 (디버깅용)
public struct ReceivingCallView: View {
    var callInfo: IncomingCallPayload
    
    public var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Text("임시 발신자 정보")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("ID: \(callInfo.callerId)")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("전화가 왔습니다")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 60) {
                    // 거절 버튼
                    Button {
                        Task {
                            await CallManager.shared.denyCall()
                        }
                    } label: {
                        VStack {
                            Image(systemName: "phone.down.fill")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                            Text("거절")
                        }
                        .foregroundColor(.white)
                    }
                    
                    // 수락 버튼
                    Button {
                        Task {
                            await CallManager.shared.acceptCall()
                        }
                    } label: {
                        VStack {
                            Image(systemName: "phone.fill")
                                .font(.largeTitle)
                                .padding()
                                .background(Color.green)
                                .clipShape(Circle())
                            Text("수락")
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 80)
            }
        }
    }
}
