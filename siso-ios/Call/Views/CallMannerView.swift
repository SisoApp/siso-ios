//
//  CallMannerView.swift
//  call
//
//  Created by jdios on 8/25/25.
//

import SwiftUI
import designSystem
import model

// 발신자의 첫 화면
public struct CallMannerView: View {
    // 전달은 홈에서 부터
    var opponentProfile: UserProfileServer
    var delegate: CallCoordinatorDelegate?
    
    public init(opponentProfile: UserProfileServer, delegate: CallCoordinatorDelegate? = nil) {
        self.opponentProfile = opponentProfile
        self.delegate = delegate
    }
    
   
    private let mannerSettings: [(String, String)] = [
        ("1", "상대방의 이름, 연락처, 주소 등\n개인정보는 묻지 않아요."),
        ("2", "욕설, 정치·종교 논쟁 등\n무례한 질문은 금지예요."),
        ("3", "마음이 맞지 않더라도,\n예의를 지켜주세요."),
    ]
    public var body: some View {
        VStack {
            Text("🤝 전화 시작 전 약속")
                .font(.system(size: 24, weight: .bold))
                .padding(.top, 30)
            
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 50){
                    ForEach(mannerSettings, id: \.self.0) { tuple in
                        mannerView(number: tuple.0, text: tuple.1)
                    }
                }
                Spacer()
            }.padding(.horizontal)
            
            Spacer()
            
            Button {
                print("확인했어요 전화 시작")
                // 전화 시작
                CallManager.shared.startCall(to: opponentProfile)
                
                delegate?.pushCall(.activeCall)
            } label: {
                Text("확인했어요")
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 90)
                            .foregroundStyle(Color.Siso.Primary._40)
                    }
                    .padding()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    // 뒤로 가기 액션 (Coordinator Delegate 사용)
                    delegate?.pop()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black) // 색상 지정
                }
            }
        }
    }
    
    @ViewBuilder
    func mannerView(number: String, text: String) -> some View {
        HStack {
            Text(number)
                .font(.system(size: 18))
                .foregroundStyle(.black)
                .padding(7)
                .background(
                    Circle()
                        .fill(Color.Siso.Primary._40)
                )
                .padding(.trailing)
            
            Text(text)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.black)
        }
    }
    
   
}

