//
//  SettingView.swift
//  mypage
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

enum Setting: String, Identifiable, CaseIterable {
    case account = "계정"
    case notification = "알림"
    case inquiry = "문의하기"
    case payment = "결제 내역 조회"
    case policy = "개인정보 처리방침"
    case legal = "법적고지"
    case withdraw = "회원탈퇴"
    
    var id: String { self.rawValue }
}

public struct SettingView: View {
    weak var delegate: MyPageCoordinatorDelegate?
    
    public init(delegate: MyPageCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        settingList()
            .padding(.top, 27)
            .navigationTitle("설정")
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
    
    private func settingList() -> some View {
        return List(Setting.allCases, id: \.self) { item in
            Text(item.rawValue)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(item == .withdraw ? Color.Siso.Gray._50 : .black)
                .padding(.vertical, 8)
                .onTapGesture {
                    switch item {
                    case .notification:
                        break 
                    default:
                        break
                    }
                }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        SettingView(delegate: nil)
    }
}
