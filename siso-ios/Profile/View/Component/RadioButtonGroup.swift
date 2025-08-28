//
//  RadioButtonGroup.swift
//  profile
//
//  Created by 멘태 on 8/28/25.
//

import SwiftUI
import designSystem

public protocol RadioButtonOption: Hashable {
    var value: String { get }
    var text: String { get }
}

public enum Sex: String, CaseIterable, RadioButtonOption {
    case female = "여성"
    case male = "남성"
    
    public var value: String { self.rawValue }
    public var text: String { String(describing: self).uppercased() }
}

public enum TargetSex: String, CaseIterable, RadioButtonOption {
    case female = "여성"
    case male = "남성"
    case other = "상관없음"
    
    public var value: String { self.rawValue }
    public var text: String { String(describing: self).uppercased() }
}

public struct RadioButtonGroup<T: RadioButtonOption>: View {
    let title: String
    let subTitle: String?
    let options: [T]
    @Binding var selection: T?
    
    public init(title: String, subTitle: String? = nil, options: [T], selection: Binding<T?>) {
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
            ForEach(options, id: \.self) { option in
                radioButton(for: option)
            }
            Spacer()
        }
    }
    
    private func radioButton(for option: T) -> some View {
        let isSelect: Bool = selection == option
        
        return HStack(spacing: 0) {
            Text(option.value)
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
            selection = option
        }
    }
}
