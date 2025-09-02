//
//  ReligionProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct ReligionProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var religion: String
    
    private var viewModel: ReligionProfileViewModel = .init()
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._religion = State(wrappedValue: userProfile.religion)
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            informationText()
            religionButtonGroup()
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
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func informationText() -> some View {
        return Text("종교가 있나요?")
            .font(.system(size: 24))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func religionButtonGroup() -> some View {
        return TagGroup {
            ForEach(ProfileOptions.getReligionOptions(), id: \.0) { (value, title) in
                religionButton(title: title, value: value)
            }
        }
    }
    
    private func religionButton(title: String, value: String) -> some View {
        let isContain: Bool = religion == value
        
        return Button {
            religion = isContain ? "" : value
            print(religion)
        } label: {
            Text(title)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._90)
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isContain ? Color.Siso.Primary.main : Color.Siso.Gray._20)
        )
        .frame(height: 48)
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = !religion.isEmpty
        
        return PrimaryButton(title: "완료하기", isActive: isActive) {
            userProfile.religion = religion
            delegate?.pop()
        }
        .frame(height: 54)
        .padding(.bottom, 38)
    }
}

#Preview {
    NavigationStack {
        ReligionProfileView(delegate: nil, userProfile: .empty)
    }
}
