//
//  AuthCoordinatorDelegate.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

public protocol AuthCoordinatorDelegate {
    func pushAuth(_ page: AuthPage)
    func pop()
    func popToRoot()
    func changeAuthToProfile()
}
