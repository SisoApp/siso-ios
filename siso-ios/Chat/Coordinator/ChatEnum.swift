//
//  ChatEnum.swift
//  siso-ios
//
//  Created by 김용해 on 8/20/25.
//

public enum ChatPage: String, Identifiable, Hashable {
    case main, detail
    
    public var id: String { self.rawValue }
}

public enum ChatSheet: String, Identifiable, Hashable {
    case chat

    public var id: String { self.rawValue }
}
