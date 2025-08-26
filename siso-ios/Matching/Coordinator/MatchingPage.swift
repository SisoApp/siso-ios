//
//  MatchingPage.swift
//  matching
//
//  Created by jdios on 8/16/25.
//

import Foundation

public enum MatchingPage: String, Identifiable, Hashable {
    
    case tutorial, profileWriteDemand, home
    
    public var id: String {self.rawValue}
    
    
}

public enum MatchingSheet: String, Identifiable, Hashable {
    case fullScreenProfile
    
    public var id: String {self.rawValue}
}

