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
    
    private let viewModel: InterestProfileViewModel = InterestProfileViewModel()
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            informationText()
            interestButtonScrollView()
            nextButton()
        }
        .background(.white)
        .padding(.horizontal)
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
    }
    
    private func informationText() -> some View {
        return Group {
            Text("나의 관심을 선택해주세요")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 3개 이상 선택해주세요\n많이 고를수록 매칭 확률이 높아져요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.Siso.Gray._60)
                .lineSpacing(9)
                .padding(.top, 8)
        }
    }
    
    private func interestButton(_ title: String) -> some View {
        let isActive: Bool = interests.contains(title)
        
        return Button {
            if isActive {
                guard let index: Int = interests.firstIndex(of: title) else { return }
                interests.remove(at: index)
            } else {
                interests.append(title)
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
                ForEach(InterestType.allCases, id: \.self) { type in
                    Text(type.id)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.Siso.Gray._50)
                        .padding(.top, 12)
                    
                    ForEach(viewModel.chucked(type, into: 2), id: \.self) { chunk in
                        HStack {
                            ForEach(chunk, id: \.self) { item in
                                interestButton(item)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding(.vertical, 12)
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = interests.count > 2
        
        return Button {
            userProfile.interests = interests
            delegate?.pop()
        } label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .padding(.bottom, 8)
        .disabled(!isActive)
    }
}

#Preview {
    NavigationStack {
        InterestProfileView(delegate: nil, userProfile: .empty)
    }
}
