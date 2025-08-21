//
//  CallPage.swift
//  call
//
//  Created by jdios on 8/20/25.
//

import Foundation

public enum CallPage: String, Identifiable, Hashable {
    case connecting, calling, called
    
    public var id: String {self.rawValue}
}

public enum CallSheet: String, Identifiable, Hashable {
    case afterCallPopup
    
    public var id: String { self.rawValue }
    
}
