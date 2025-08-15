//
//  RecordProfileView.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import SwiftUI

public struct RecordProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RecordProfileView(delegate: nil, userProfile: .empty)
}
