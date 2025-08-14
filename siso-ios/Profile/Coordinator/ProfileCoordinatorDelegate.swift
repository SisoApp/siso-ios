//
//  ProfileCoordinatorDelegate.swift
//  profile
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

public protocol ProfileCoordinatorDelegate {
    func pushProfile(_ page: ProfilePage)
    func pop()
    func popToRoot()
    func presentProfile(sheet: ProfileSheet)
    func dismissProfileSheet()
    func changeProfileToMatching()
}
