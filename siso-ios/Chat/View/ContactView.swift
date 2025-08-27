//
//  ContactView.swift
//  chat
//
//  Created by 김용해 on 8/20/25.
//

import SwiftUI

extension ChatMainView {
    struct ContactView: View {
        let userName: String
        let icon: String
        let time: String
        let type: ContactType
        var hasMessage: Bool?
        var recentMessage: String?
        
        init(userName: String, icon: String, time: String, type: ContactType, hasMessage: Bool? = nil, recentMessage: String? = nil) {
            self.userName = userName
            self.icon = icon
            self.time = time
            self.type = type
            self.hasMessage = hasMessage
            self.recentMessage = recentMessage
        }
        
        // TODO: 각 연락처 내부 정보 뷰
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 56, height: 56)
                
                switch type {
                    case .callList:
                        Text(userName)
                            .font(.system(size: 18))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .lineSpacing(5.4)
                            .lineLimit(1)
                        Text(time)
                            .foregroundStyle(Color.Siso.Gray._50)
                            .font(.system(size: 15, weight: .regular))
                            .tracking(-0.15)
                    case .recentChat:
                        VStack(alignment: .leading) {
                            Text(userName)
                                .font(.system(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineSpacing(5.4)
                                .lineLimit(1)
                            Spacer()
                            if let recentMessage = recentMessage {
                                Text(recentMessage)
                                    .lineLimit(1)
                                    .font(.system(size: 18)).fontWeight(.regular)
                                    .foregroundStyle(Color.Siso.Gray._50)
                                    .tracking(-0.54)
                            }
                        }
                        VStack(alignment: .trailing) {
                            Text(time)
                                .foregroundStyle(Color.Siso.Gray._50)
                                .font(.system(size: 15, weight: .regular))
                                .tracking(-0.15)
                            if let hasMessage = hasMessage {
                                if hasMessage {
                                    ZStack {
                                        Circle()
                                            .frame(maxWidth: 24)
                                            .foregroundStyle(Color.Siso.Primary.main)
                                        Text("N")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                }else {
                                    Spacer()
                                }
                            }
                        }
                }
                
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.Siso.Gray._30),
                alignment: .bottom
            )
        }
    }
}
