//
//  NotificationView.swift
//  chat
//
//  Created by 김용해 on 8/28/25.
//

import SwiftUI

public struct NotificationChatView: View {
    @Environment(\.dismiss) private var dismiss
    public init() {}
    
    public var body: some View {
        VStack(alignment: .leading) {
            ForEach(notices) { notice in
                VStack(alignment: .leading,spacing: 16) {
                    Text(notice.title)
                        .font(.system(size: 18, weight: .semibold))
                        .lineSpacing(5.4)
                        .tracking(-0.03)
                    Text(notice.subTitle)
                        .font(.system(size: 18))
                        .lineSpacing(9)
                        .tracking(-0.03)
                }
                .padding(.vertical)
                Divider()
            }
            Spacer()
        }
        .toolbar(.hidden, for: .tabBar)
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension NotificationChatView {
    var notices: [Notice] {
        [
            Notice(
                title: "새로운 인연이 부재중을 남겼어요!",
                subTitle: "알림내용입니다. 해당알림을 터치하면 채팅창으로 이동하여 새로운 인연이 남긴 부재중을 확인할 수 있어요"
            ),
            Notice(
                title: "(광고) 월 4,900원으로 새로운 인연 만나기",
                subTitle: "터치시 맴버십 가입 페이지로 이동"
            ),
            Notice(
                title: "새로운 인연이 채팅을 보냈어요",
                subTitle: "알림내용입니다. 해당알림을 터치하면 채팅창으로 이동하여 새로운 인연이 보낸 채팅을 확인할 수 있어요"
            )
        ]
    }
}

#Preview {
    NavigationStack {
        NotificationChatView()
    }
}
