//
//  NotificationView.swift
//  chat
//
//  Created by 김용해 on 8/28/25.
//

import SwiftUI
import model

public struct NotificationCommonView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: NotificationViewModel
    
   public init(viewModel: NotificationViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            ForEach(viewModel.notifications) { notification in
                NoticficationCellView(title: notification.title,
                                      message: notification.message,
                                      isRead: notification.isRead)
                .padding()
                Divider()
            }
            Spacer()
        }
        .toolbar(.hidden, for: .tabBar)
        .padding()
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        
        .task {
            await viewModel.fetchNotifications()
        }
    }
}

public struct NoticficationCellView: View {
    let title: String
    let message: String
    let isRead: Bool
   public var body: some View {
        
    }
    private var notificationCell: some View {
        VStack(alignment: .leading,spacing: 16) {
            Text(title)
                .font(.title)
            Text(message)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
        .background(isRead ? .white : Color.gray.opacity(0.2))
    }
    
    
    
}
