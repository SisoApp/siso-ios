//
//  Font+Extension.swift
//  extensions
//
//  Created by jdios on 8/12/25.
//

import SwiftUI

public enum AppFontName: String {
    case regular = "JejuMyeongjoOTF" // PostScript 이름

}

public extension Font {
    static func appFont(name: AppFontName, size: CGFloat) -> Font {
        return Font.custom(name.rawValue, size: size)
    }
}
