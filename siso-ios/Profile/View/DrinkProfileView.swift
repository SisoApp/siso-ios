//
//  DrinkProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct DrinkProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var drinking: String
    
    private var viewModel: DrinkProfileViewModel = .init()
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._drinking = State(wrappedValue: userProfile.drinking)
    }
    
    public var body: some View {
        VStack {
            informationText()
            buttonGroup()
            Spacer()
            completeButton()
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
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
            Text("음주 습관을 알려주세요.\n서로 이해하는 데 도움이 돼요")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 1개 이상 선택해주세요")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
        }
    }
    
    private func buttonGroup() -> some View {
        return VStack(alignment: .leading, spacing: 12) {
            ForEach(ProfileOptions.getDrinkingCapacityOptions(), id: \.0) { (value, title) in
                drinkingButton(title: title, value: value)
            }
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func drinkingButton(title: String, value: String) -> some View {
        let isContain: Bool = drinking == value
        
        return Button {
            drinking = isContain ? "" : value
        } label: {
            Text(title)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._90)
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
        }
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isContain ? Color.Siso.Primary.main : Color.Siso.Gray._20)
        )
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = !drinking.isEmpty
        
        return PrimaryButton(title: "완료하기", isActive: isActive) {
            userProfile.drinking = drinking
            delegate?.pop()
        }
        .padding(.bottom, 38)
    }
}

#Preview {
    NavigationStack {
        DrinkProfileView(delegate: nil, userProfile: .empty)
    }
}
