//
//  RadioButtonGroup.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

struct RadioButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(label)
            
            Image(systemName: isSelected ? "circle.inset.filled" : "circle")
                .foregroundStyle(isSelected ? .black : .gray)
        }
        .onTapGesture { action() }
    }
}

struct RadioButtonGroup: View {
    @State private var selected: String
    let title: String
    let options: [String]
    
    init(title: String, options: [String]) {
        self.title = title
        self.options = options
        self._selected = State(initialValue: options[0])
    }
    
    var body: some View {
        Text(title)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 4, trailing: 16))
        
        HStack {
            ForEach(options, id: \.self) { option in
                RadioButton(label: option, isSelected: selected == option) {
                    selected = option
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 0))
            
            Spacer()
        }
    }
}

#Preview {
    RadioButtonGroup(title: "내 성별", options: ["여성", "남성"])
}
