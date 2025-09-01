//
//  SignUpProfileView.swift
//  profile
//
//  Created by 멘태 on 8/24/25.
//

import SwiftUI
import designSystem

public enum SignUpProfilePage: Int, CaseIterable {
    case basic = 1
    case image
    case introduce
    case voice
}

public struct SignUpProfileView: View {
    @ObservedObject var userProfile: UserProfile
    @State private var currentPage: SignUpProfilePage = .basic
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack {
            progressView()
            registerView()
        }
        .navigationTitle("내 정보 입력")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .animation(.easeInOut, value: currentPage)
    }
    
    
    private func progressView() -> some View {
        return HStack(spacing: 12) {
            circleView(page: 1)
            lineView(page: 2)
            circleView(page: 2)
            lineView(page: 3)
            circleView(page: 3)
            lineView(page: 4)
            circleView(page: 4)
        }
        .padding(.horizontal)
    }
    
    private func circleView(page: Int) -> some View {
        return Circle()
            .fill(page <= currentPage.rawValue ? Color.Siso.Primary.main : .Siso.Gray._30)
            .frame(width: 36)
            .overlay {
                Text(page.description)
                    .foregroundStyle(page <= currentPage.rawValue ? .black : .Siso.Gray._50)
            }
    }
    
    private func lineView(page: Int) -> some View {
        return RoundedRectangle(cornerRadius: 12)
            .fill(page <= currentPage.rawValue ? Color.Siso.Primary.main :  Color.Siso.Gray._30)
            .frame(height: 4)
            .padding(.horizontal, 4.5)
    }
    
    private func registerView() -> some View {
        return Group {
            switch currentPage {
            case .basic:
                BasicProfileView(currentPage: $currentPage, userProfile: userProfile)
            case .image:
                ImageProfileView(delegate: delegate, currentPage: $currentPage, userProfile: userProfile, mode: .signUp)
            case .introduce:
                IntroduceProfileView(currentPage: $currentPage, userProfile: userProfile)
            case .voice:
                RecordProfileView(delegate: delegate, currentPage: $currentPage, userProfile: userProfile, mode: .signUp)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SignUpProfileView(delegate: nil, userProfile: .empty)
    }
}
