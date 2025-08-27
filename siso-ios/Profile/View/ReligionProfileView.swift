//
//  ReligionProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

enum Religion: String, Identifiable, CaseIterable {
    case christianity = "기독교"
    case catholic = "천주교"
    case buddhism = "불교"
    case wonBuddhism = "원불교"
    case none = "무교"
    case other = "기타/(직접입력)"
    
    var id: String { rawValue }
}

public struct ReligionProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var religion: String
    
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
    }
    
    private func informationText() -> some View {
        return Text("종교가 있나요?")
            .font(.system(size: 24))
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func religionButtonGroup() -> some View {
        let first = Religion.allCases.prefix(Religion.allCases.count / 2)
        let second = Religion.allCases.suffix(Religion.allCases.count / 2)
        
        return VStack {
            HStack(spacing: 12) {
                ForEach(first) { religion in
                    religionButton(religion)
                }
                Spacer()
            }
            .padding(.top, 24)
            .padding(.bottom, 4)
            
            HStack(spacing: 12) {
                ForEach(second) { religion in
                    religionButton(religion)
                }
                Spacer()
            }
        }
    }
    
    private func religionButton(_ item: Religion) -> some View {
        let isContain: Bool = religion == item.rawValue
        
        return Button {
            switch item {
            case .other:
                delegate?.presentProfile(sheet: .religion)
            default:
                religion = isContain ? "" : item.rawValue
            }
        } label: {
            Text(item.rawValue)
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
        
        return Button {
            userProfile.religion = religion
            delegate?.pop()
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
        .padding(.bottom, 38)
    }
}

#Preview {
    NavigationStack {
        ReligionProfileView(delegate: nil, userProfile: .empty)
    }
}
