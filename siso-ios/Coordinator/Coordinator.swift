//
//  Coordinator.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI
import profile

public class Coordinator: ObservableObject, ProfileCoordinatorDelegate {
    @Published public var path: NavigationPath = NavigationPath()
    @Published var profileSheet: ProfilesSheet?
    
    public init() {}
    
    // Auth
    
    // Matching
    
    // Profile
    public func pushProfile(_ page: ProfilePage) {
        path.append(page)
    }
    
    public func presentProfile(sheet: ProfilesSheet) {
        self.profileSheet = sheet
    }
    
    public func popProfile() {
        path.removeLast()
    }
    
    public func popToProfileRoot() {
        path.removeLast(path.count)
    }
    
    public func buildProfileView(_ page: ProfilePage) -> AnyView {
        AnyView(build(page))
    }
    
    @ViewBuilder
    public func build(_ page: ProfilePage) -> some View {
        switch page {
        case .basic:
            BasicProfileView(delegate: self)
        case .hobby:
            HobbyProfileView(delegate: self)
        }
    }
}
