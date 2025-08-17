//
//  DimmedView.swift
//  matching
//
//  Created by jdios on 8/11/25.
//

import SwiftUI

public struct MatchingDimmedView1: View {
    public init(){}
    public var body: some View {
        VStack {
            Spacer()
            Image (systemName: "arrow.up")
            Text("위로 올려 다른 인연을 찾아볼 수 있어요")
            Spacer()
        }
    }
}

public struct MatchingDimmedView2: View {
    public init(){}
    public var body: some View {
        VStack {
            Spacer()
            Image (systemName: "waveform")
            Text("녹음된 음성을 듣고 인연을 만들어보세요")
            Spacer()
        }
    }
}

public struct MatchingDimmedView3: View {
    public init(){}
    public var body: some View {
        VStack {
            Spacer()
            Image (systemName: "arrow.up")
            Text("인증 뱃지로\n안전하게 소통하세요")
            Spacer()
        }
    }
}
