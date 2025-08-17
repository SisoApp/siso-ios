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
    
    public var delegate: ProfileCoordinatorDelegate?
    private let viewModel: InterestProfileViewModel = InterestProfileViewModel()
    
    public init(delegate: ProfileCoordinatorDelegate?,
                userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(
                currentPage: 2,
                title: "나의 관심사를 선택해주세요",
                subTitle: "최소 3개 이상 선택해주세요\n많이 고를수록 매칭 확률이 높아져요\n정보는 나중에 수정할 수 있어요"
            )
            
            interestButtonScrollView()
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
    
    private func interestButton(_ title: String) -> some View {
        let isActive: Bool = userProfile.interests.contains(title)
        
        return Button {
            if isActive {
                guard let index = userProfile.interests.firstIndex(of: title) else { return }
                userProfile.interests.remove(at: index)
            } else {
                userProfile.interests.append(title)
            }
        } label: {
            Text(title)
                .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
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
                ForEach(InterestType.allCases, id: \.self) { type in
                    Text(type.id)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Siso.Gray._50)
                        .padding(.top, 12)
                    
                    ForEach(viewModel.chucked(type, into: 3), id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.self) { item in
                                interestButton(item)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(.top, 12)
            .padding(.horizontal)
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = userProfile.interests.count > 2
        
        return Button {
            delegate?.pushProfile(.image)
        } label: {
            Text("계속하기")
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
        .padding(.horizontal)
    }
    
    private func skipButton() -> some View {
        return Button {
            delegate?.pushProfile(.image)
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .padding(8)
    }
}

#Preview {
    NavigationStack {
        InterestProfileView(delegate: nil, userProfile: .empty)
    }
}
