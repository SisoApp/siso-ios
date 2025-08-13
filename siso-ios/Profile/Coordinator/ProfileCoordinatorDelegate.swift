//
//  ProfileCoordinatorDelegate.swift
//  profile
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

public protocol ProfileCoordinatorDelegate {
    func pushProfile(_ page: ProfilePage)
    func presentProfile(sheet: ProfilesSheet)
    func popProfile()
    func popToProfileRoot()
    func buildProfileView(_ page: ProfilePage) -> AnyView
}
