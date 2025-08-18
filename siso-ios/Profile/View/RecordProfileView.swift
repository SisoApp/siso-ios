//
//  RecordProfileView.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import SwiftUI
import designSystem
import Combine

public struct RecordProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @StateObject private var viewModel: RecordProfileViewModel
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._viewModel = StateObject(wrappedValue: RecordProfileViewModel(userProfile: userProfile)
        )
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(
                currentPage: 5,
                title: "내 목소리를 들려주세요",
                subTitle: "직접 전하는 목소리는 신뢰를 더해줍니다\n상대방이 회원님을 더 깊이 이해하고 좋은 인상을 받을 수 있도록, 간단한 인삿말을 20초 내로 녹음하여 나를 알려주세요"
            )
            
            Image(viewModel.symbolName)
                .resizable()
                .frame(width: 98, height: 98)
                .padding(.top, 98)
                .onTapGesture {
                    switch viewModel.status {
                    case .pending:
                        break
                    case .recording:
                        viewModel.stopRecording()
                    case .waiting:
                        viewModel.startPlaying()
                    case .playing:
                        viewModel.stopPlaying()
                    }
                }
            
            Text("00:\(String(format: "%02d", viewModel.playTime))")
                .font(.system(size: 22))
                .fontWeight(.bold)
                .padding(.top, 56)

            Spacer()
            
            Group {
                switch viewModel.status {
                case .pending:
                    pendingBottomView()
                case .recording, .waiting, .playing:
                    doneBottomView()
                }
            }
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
    
    private func pendingBottomView() -> some View {
        return VStack {
            recordButton()
            skipButton()
        }
    }
    
    private func doneBottomView() -> some View {
        return VStack {
            nextButton()
            restartButton()
        }
    }
    
    private func recordButton() -> some View {
        let isActive: Bool = viewModel.recordButtonIsActive
        
        return Button {
            viewModel.startRecoding()
        } label: {
            Text("녹음시작")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .frame(height: 54)
        .padding(.horizontal)
    }
    
    private func skipButton() -> some View {
        return Button {
            delegate?.pushProfile(.complete)
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 54)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = viewModel.nextButtonIsActive
        
        return Button {
            delegate?.pushProfile(.complete)
        } label: {
            Text("완료하기")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18)) 
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .frame(height: 54)
        .padding(.horizontal)
    }
    
    private func restartButton() -> some View {
        let isActive: Bool = viewModel.restartButtonIsActive
        
        return Button {
            viewModel.startRecoding()
        } label: {
            Text("다시 녹음하기")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
        }
        .disabled(!isActive)
        .frame(height: 54)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

#Preview {
    NavigationStack {
        RecordProfileView(delegate: nil, userProfile: .empty)
    }
}
