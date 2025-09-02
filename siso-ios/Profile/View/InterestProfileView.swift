//
//  HobbyProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI
import designSystem

public struct InterestProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var interests: [String] = []
    
    private var viewModel: InterestProfileViewModel = .init()
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._interests = State(wrappedValue: userProfile.interests)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            informationText()
            interestButtonScrollView()
            nextButton()
        }
        .background(.white)
        .padding()
        .navigationTitle("내 정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        delegate?.pop()
                    }
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func informationText() -> some View {
        return Group {
            Text("나의 관심을 선택해주세요")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 3개 이상, 7개 이하로  선택해주세요\n많이 고를수록 매칭 확률이 높아져요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.Siso.Gray._60)
                .lineSpacing(9)
                .padding(.top, 8)
        }
    }
    
    private func interestButton(title: String, value: String) -> some View {
        let isActive: Bool = interests.contains(value)
        
        return Button {
            if isActive {
                guard let index: Int = interests.firstIndex(of: value) else { return }
                interests.remove(at: index)
            } else {
                if interests.count < 7 {
                    interests.append(value)
                }
            }
        } label: {
            Text(title)
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                .frame(height: 48)
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._90)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._20)
                .clipShape(.rect(cornerRadius: 24))
        }
    }
    
    private func interestButtonScrollView() -> some View {
        return ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.interestOptions, id: \.0) { category, options in
                    Text(category)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.Siso.Gray._50)
                        .padding(.top, 12)
                    
                    TagGroup {
                        ForEach(options, id: \.0) { (value, title) in
                            interestButton(title: title, value: value)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = interests.count > 2
        
        return PrimaryButton(title: "계속하기", isActive: isActive) {
            userProfile.interests = interests
            delegate?.pop()
        }
    }
}

#Preview {
    NavigationStack {
        InterestProfileView(delegate: nil, userProfile: .empty)
    }
}
