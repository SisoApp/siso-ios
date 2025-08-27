//
//  AuthCoordinatorDelegate.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

public protocol ChatCoordinatorDelegate {
    func pushChat(_ page: ChatPage)
    func pop()
    func popToRoot()
}
