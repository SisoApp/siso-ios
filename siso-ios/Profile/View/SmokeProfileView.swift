//
//  SmokeProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

enum SmokingStatus: CaseIterable {
    case yes, no
    
    var rawValue: Bool {
        switch self {
        case .yes:
            return true
        case .no:
            return false
        }
    }
    
    var text: String {
        switch self {
        case .yes: return "흡연자"
        case .no: return "비흡연자"
        }
    }
}

public struct SmokeProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var smoking: Bool
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._smoking = State(wrappedValue: userProfile.smoking)
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
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func informationText() -> some View {
        return Group {
            Text("흡연 여부를 알려주시면\n더 잘 맞는 분과 연결해 드려요")
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
        return HStack(spacing: 12) {
            ForEach(SmokingStatus.allCases, id: \.self) { item in
                smokingButton(item)
            }
            Spacer()
        }
        .padding(.top, 24)
    }
    
    private func smokingButton(_ status: SmokingStatus) -> some View {
        let isContain: Bool = smoking == status.rawValue
        
        return Button {
            self.smoking = status.rawValue
        } label: {
            Text(status.text)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._90)
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
        }
        .frame(height: 48)
        .background(
            RoundedRectangle(cornerRadius: 48 / 2)
                .fill(isContain ? Color.Siso.Primary.main : Color.Siso.Gray._20)
        )
    }
    
    private func completeButton() -> some View {
        return PrimaryButton(title: "완료하기", isActive: true) {
            userProfile.smoking = smoking
            delegate?.pop()
        }
        .padding(.bottom, 38)
    }
}

#Preview {
    SmokeProfileView(delegate: nil, userProfile: .empty)
}
