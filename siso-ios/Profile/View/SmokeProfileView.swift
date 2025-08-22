//
//  SmokeProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

enum SmokingFrequency: String, Identifiable, CaseIterable {
    case veryOften = "매우 자주 피워요 (하루에 1갑 이상)"
    case often = "자주 피워요 (하루에 반갑 이상)"
    case sometimes = "가끔 피워요 (일주일에 몇 번 정도)"
    case none = "비흡연자"
    
    var id: String { self.rawValue }
}

public struct SmokeProfileView: View {
    @ObservedObject var userProfile: UserProfile
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack {
            Text("흡연 여부를 알려주시면\n더 잘 맞는 분과 연결해 드려요")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 1개 이상 선택해주세요")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            
            buttonStack()
            
            Spacer()
            
            completeButton()
        }
        .padding(EdgeInsets(top: 40, leading: 16, bottom: 0, trailing: 16))
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
    
    private func buttonStack() -> some View {
        return VStack(alignment: .leading, spacing: 12) {
            ForEach(SmokingFrequency.allCases, id: \.self) { item in
                Button {
                    
                } label: {
                    Text(item.rawValue)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.Siso.Gray._90)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 18)
                }
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.Siso.Gray._20)
                )
            }
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = true
        
        return Button {
            delegate?.pushProfile(.interest)
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
    SmokeProfileView(delegate: nil, userProfile: .empty)
}
