//
//  DimmedView.swift
//  matching
//
//  Created by jdios on 8/11/25.
//

import SwiftUI

struct MatchingDimmedView1: View {
    var body: some View {
        VStack {
            Spacer()
            Image (systemName: "arrow.up")
            Text("위로 올려 다른 인연을 찾아볼 수 있어요")
            Spacer()
        }
    }
}

struct MatchingDimmedView2: View {
    var body: some View {
        VStack {
            Spacer()
            Image (systemName: "waveform")
            Text("녹음된 음성을 듣고 인연을 만들어보세요")
            Spacer()
        }
    }
}

struct MatchingDimmedView3: View {
    var body: some View {
        VStack {
            Spacer()
            Image (systemName: "arrow.up")
            Text("인증 뱃지로\n안전하게 소통하세요")
            Spacer()
        }
    }
}
