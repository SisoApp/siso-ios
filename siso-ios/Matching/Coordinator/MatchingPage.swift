//
//  MatchingPage.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import Foundation

public enum MatchingPage: String, Identifiable, Hashable {
    case home, call, chat, popup, beCalled
    
    public var id: String {self.rawValue}
}
