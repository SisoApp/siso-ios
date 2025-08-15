//
//  RecordProfileView.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import SwiftUI
import designSystem

public struct RecordProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    
    weak var delegate: ProfileCoordinatorDelegate?
    private var isActive: Bool = true
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(
                currentPage: 5,
                title: "내 목소리를 들려주세요",
                subTitle: "직접 전하는 목소리는 신뢰를 더해줍니다\n상대방이 회원님을 더 깊이 이해하고 좋은 인상을 받을 수 있도록, 간단한 인삿말을 20초 내로 녹음하여 나를 알려주세요"
            )
            
            Image(systemName: "microphone")
                .resizable()
                .scaledToFit()
                .fontWeight(.semibold)
                .symbolEffect(.pulse)
                .frame(width: 40, height: 40)
                .frame(width: 98, height: 98)
                .foregroundStyle(.white)
                .background(Color.Siso.Red._50)
                .clipShape(.rect(cornerRadius: 49))
                .padding(.top, 98)
            
            Text("00:00")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(.top, 40)

            Spacer()
            
            nextButton()
            skipButton()
        }
        .navigationTitle("내 정보 입력")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        delegate?.pop()
                    }
            }
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = true
        
        return Button {
            
        } label: {
            Text("녹음시작")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .overlay {
                    RoundedRectangle(cornerRadius: 27)
                        .stroke(
                            isActive ? Color.Siso.Primary._80 : Color.Siso.Gray._40,
                            lineWidth: 1
                        )
                }
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .padding()
    }
    
    func skipButton() -> some View {
        return Button {
            
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .padding(.bottom, 43)
        }
    }
}

#Preview {
    NavigationStack {
        RecordProfileView(delegate: nil, userProfile: .empty)
    }
}
