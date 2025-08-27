//
//  ReligionProfileSheet.swift
//  profile
//
//  Created by 멘태 on 8/27/25.
//

import SwiftUI
import designSystem

public struct ReligionProfileSheet: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var religion: String = ""
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        religionSheet()
            .presentationDetents([.height(200)])
            .presentationCornerRadius(24)
    }
    
    private func religionSheet() -> some View {
        return VStack {
            topHStack()
            textFieldView()
            completeButton()
        }
        .padding()
    }
    
    private func topHStack() -> some View {
        return HStack {
            Spacer().frame(width: 16)
            Spacer()
            
            Text("종교 입력")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.Siso.Gray._90)
            
            Spacer()
            
            Image(systemName: "xmark")
                .resizable()
                .scaledToFill()
                .bold()
                .frame(width: 16, height: 16)
                .foregroundStyle(Color.Siso.Gray._90)
                .onTapGesture {
                    delegate?.dismissProfileSheet()
                }
        }
        .padding(.horizontal)
        .padding(.top, 30)
    }
    
    private func textFieldView() -> some View {
        return HStack {
            TextField("종교명을 입력해주세요.", text: $religion)
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._50)
            
            Image("pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.Siso.Gray._40)
        }
        .padding(.horizontal)
        .frame(height: 54)
        .background(
            RoundedRectangle(cornerRadius: 54 / 2)
                .fill(Color.Siso.Gray._20)
        )
        .padding(.top, 30)
    }
    
    private func completeButton() -> some View {
        return Button {
            userProfile.religion = religion
            delegate?.dismissProfileSheet()
            delegate?.pop()
        } label: {
            Text("완료하기")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._90)
        }
        .frame(height: 54)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 54 / 2)
                .fill(Color.Siso.Primary.main)
        )
    }
}

#Preview {
    ReligionProfileSheet(delegate: nil, userProfile: .empty)
}
