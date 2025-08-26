//
//  CallDelegate.swift
//  call
//
//  Created by jdios on 8/19/25.
//

import Foundation

public protocol CallCoordinatorDelegate: AnyObject {
    
    func pushCall(_ call: CallPage)
    
    func pop()
    
    func popToRoot()
}

