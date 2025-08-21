//
//  MatchingPage.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import Foundation

public enum MatchingPage: String, Identifiable, Hashable {
    case home, chat, connecting
    
    public var id: String {self.rawValue}
    
    
}

