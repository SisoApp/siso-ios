//
//  MeetingProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct MeetingProfileView: View {
    @ObservedObject var userProfile: UserProfile
    
    private var viewModel: MeetingProfileViewModel = MeetingProfileViewModel()
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack {
            Text("이런 인연을 만나고 싶어요")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 3개 이상 선택해주세요\n많이 고를수록 매칭 확률이 높아져요")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            
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
    
    private func meetingButton(_ title: String) -> some View {
        return Button {
            
        } label: {
            Text(title)
                .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
                .frame(height: 48)
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._90)
                .background(Color.Siso.Gray._20)
                .clipShape(.rect(cornerRadius: 24))
        }
    }
    
    private func meetingButtonScrollView() -> some View {
        return ScrollView {
            ForEach(viewModel.chucked(into: 2), id: \.self) { chunk in
                HStack {
                    ForEach(chunk, id: \.self) { meeting in
                        meetingButton(meeting)
                    }
                    Spacer()
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = true
        
        return Button {
            delegate?.pushProfile(.complete)
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
    }
}

#Preview {
    NavigationStack {
        MeetingProfileView(delegate: nil, userProfile: .empty)
    }
}
