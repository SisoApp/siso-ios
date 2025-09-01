//
//  RadioButtonGroup.swift
//  profile
//
//  Created by 멘태 on 8/28/25.
//

import SwiftUI
import designSystem

public struct RadioButtonGroup: View {
    let title: String
    let subTitle: String?
    let options: [(value: String, title: String)]
    @Binding var selection: String?
    
    public init(title: String, subTitle: String? = nil, options: [(value: String, title: String)], selection: Binding<String?>) {
        self.title = title
        self.subTitle = subTitle
        self.options = options
        self._selection = selection
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            titleView()
            subTitleView()
            optionView()
        }
        .padding(.top)
    }
    
    private func titleView() -> some View {
        return Text(title)
            .padding(.top, 16)
            .font(.system(size: 18))
            .fontWeight(.semibold)
            .foregroundStyle(Color.Siso.Gray._50)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func subTitleView() -> some View {
        return Group {
            if let subTitle = subTitle {
                Text(subTitle)
                    .padding(.top, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.Siso.Gray._50)
                    .font(.system(size: 18))
                    .lineSpacing(5)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    private func optionView() -> some View {
        return HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                radioButton(for: options[index])
            }
            Spacer()
        }
    }
    
    private func radioButton(for option: (value: String, title: String)) -> some View {
        let isSelect: Bool = selection == option.value
        
        return HStack(spacing: 0) {
            Text(option.title)
                .padding(.trailing, 2)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            
            Image(systemName: isSelect ? "circle.inset.filled" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .bold()
                .foregroundStyle(isSelect ? .black : .gray)
                .padding(.trailing, 24)
        }
        .padding(.top, 12)
        .onTapGesture {
            selection = option.value
        }
    }
}
