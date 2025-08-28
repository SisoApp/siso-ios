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
    @Binding var currentPage: SignUpProfilePage
    
    private let mode: ProfileMode
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, currentPage: Binding<SignUpProfilePage>, userProfile: UserProfile, mode: ProfileMode) {
        self.delegate = delegate
        self._currentPage = currentPage
        self.userProfile = userProfile
        self._viewModel = StateObject(wrappedValue: RecordProfileViewModel(userProfile: userProfile))
        self.mode = mode
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            informationText()
            recordSymbol()
            recordTimeView()
            Spacer()
            bottomView()
        }
        .padding(.top, 60)
        .padding(.horizontal)
        .navigationTitle(mode == .signUp ? "내 정보 등록" : "내 정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        switch mode {
                        case .signUp:
                            currentPage = .introduce
                        case .edit:
                            delegate?.pop()
                        }
                    }
            }
        }
    }
    
    private func informationText() -> some View {
        return Group {
            Text("내 목소리를 들려주세요")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("직접 전하는 목소리는 신뢰를 더해줍니다\n상대방이 회원님을 더 깊이 이해하고 좋은 인상을\n받을 수 있도록 간단한 인사말을 20초내로 녹음\n하여 나를 알려주세요.")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.Siso.Gray._60)
                .lineSpacing(9)
                .padding(.top, 8)
        }
    }
    
    private func recordSymbol() -> some View {
        return Image(viewModel.symbolName)
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
    }
    
    private func recordTimeView() -> some View {
        return Text("00:\(String(format: "%02d", viewModel.playTime))")
            .font(.system(size: 22))
            .fontWeight(.bold)
            .padding(.top, 56)
    }
    
    private func bottomView() -> some View {
        return Group {
            switch viewModel.status {
            case .pending:
                pendingBottomView()
            case .recording, .waiting, .playing:
                doneBottomView()
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
        
        return PrimaryButton(title: "녹음시작", isActive: isActive) {
            viewModel.startRecoding()
        }
    }
    
    private func skipButton() -> some View {
        let isActive: Bool = mode == .signUp
        
        return Group {
            if isActive {
                Button {
                    delegate?.pushProfile(.complete)
                } label: {
                    Text("건너뛰기")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Siso.Gray._50)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 54)
            }
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = viewModel.nextButtonIsActive
        
        return PrimaryButton(title: "완료하기", isActive: isActive) {
            Task {
                await viewModel.uploadVoice()
            }
            
            switch mode {
            case .signUp:
                delegate?.pushProfile(.complete)
            case .edit:
                delegate?.pop()
            }
        }
    }
    
    private func restartButton() -> some View {
        let isActive: Bool = viewModel.restartButtonIsActive
        
        return PrimaryButton(title: "다시 녹음하기", isActive: isActive) {
            viewModel.startRecoding()
        }
    }
}

#Preview {
    NavigationStack {
        RecordProfileView(delegate: nil, currentPage: .constant(.voice), userProfile: .empty, mode: .signUp)
    }
}
