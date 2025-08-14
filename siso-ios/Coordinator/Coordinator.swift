//
//  Coordinator.swift
//  auth
//
//  Created by 멘태 on 8/13/25.
//

import SwiftUI

import auth
import profile

public enum Sheet: String, Identifiable {
    case temp
    
    public var id: String { self.rawValue }
}

public enum FullScreenCover: String, Identifiable, Hashable {
    case imageHelper
    
    public var id: String { self.rawValue }
}

public class Coordinator: ObservableObject, AuthCoordinatorDelegate, ProfileCoordinatorDelegate {
    @Published public var stackID: UUID = UUID()
    @Published public var path: NavigationPath = NavigationPath()
    @Published public var sheet: Sheet?
    @Published public var fullScreenCover: FullScreenCover?
    
    public init() {}
    
    // Comon
    public func pop() {
        path.removeLast()
    }
    
    public func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    public func build(sheet: Sheet) -> some View {
        switch sheet {
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    public func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .imageHelper:
            EmptyView()
        }
    }
    
    // Auth Page
    public func pushAuth(_ page: AuthPage) {
        path.append(page)
    }
    
    public func buildAuthView(_ page: AuthPage) -> AnyView {
        AnyView(build(page))
    }
    
    @ViewBuilder
    public func build(_ page: AuthPage) -> some View {
        switch page {
        case .login:
            SocialView(delegate: self)
        case .accept:
            AcceptanceView(delegate: self)
        case .welcome:
            WelcomeView(delegate: self)
        }
    }
    
    // Matching Page
    
    // Profile Page
    public func pushProfile(_ page: ProfilePage) {
        path.append(page)
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
    
    // Flow
    public func changeAuthToProfile() {
        stackID = UUID()
        path = NavigationPath()
        
        withAnimation(.easeInOut(duration: 0.35)) { [weak self] in
            self?.pushProfile(.basic)
        }
    }
    
    public func changeProfileToMatching() {
        
    }
    
    public func changeMatchingToAuth() {
        
    }
}
