//
//  MeetingProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct MeetingProfileView: View {
    @ObservedObject var userProfile: UserProfile
    @State private var meetings: [String] = []
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._meetings = State(wrappedValue: userProfile.meeting)
    }
    
    public var body: some View {
        VStack {
            informationText()
            meetingButtonScrollView()
            completeButton()
        }
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
    }
    
    private func informationText() -> some View {
        return Group {
            Text("이런 인연을 만나고 싶어요")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 3개 이상, 7개 이하로 선택해주세요\n많이 고를수록 매칭 확률이 높아져요")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
        }
    }
    
    private func meetingButton(title: String, value: String) -> some View {
        let isActive: Bool = meetings.contains(value)
        
        return Button {
            if isActive {
                guard let index = meetings.firstIndex(of: value) else { return }
                meetings.remove(at: index)
            } else {
                if meetings.count < 7 {
                    meetings.append(value)
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
    
    private func meetingButtonScrollView() -> some View {
        return ScrollView {
            TagGroup {
                ForEach(ProfileOptions.getMeetingOptions(), id: \.0) { (value, title) in
                    meetingButton(title: title, value: value)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = meetings.count > 2
        
        return PrimaryButton(title: "완료하기", isActive: isActive) {
            userProfile.meeting = meetings
            delegate?.pop()
        }
    }
}

#Preview {
    NavigationStack {
        MeetingProfileView(delegate: nil, userProfile: .empty)
    }
}
