//
//  Chat.swift
//  siso-ios
//
//  Created by 김용해 on 8/20/25.
//
import SwiftUI

public struct Contact: Identifiable {
    public let id: UUID = UUID()
    let userName: String
    let icon: String
    let time: Date
}
