//
//  FinishProfileView.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import SwiftUI

public struct CompleteProfileView: View {
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CompleteProfileView(delegate: nil)
}
