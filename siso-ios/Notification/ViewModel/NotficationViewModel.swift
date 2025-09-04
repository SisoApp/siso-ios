//
//  NotficationViewModel.swift
//  model
//
//  Created by jdios on 9/4/25.
//

import Foundation
import model
import network

@MainActor
public class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationResponseDto] = []
    
    public init() {}
    func fetchNotifications() async {
        do {
            let notifications = try await NetworkManager.shared.getNotifications()
            self.notifications = notifications
        } catch {
            print(error.localizedDescription)
        }
    }
}


