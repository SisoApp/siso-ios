//
//  AcceptanceView.swift
//  auth
//
//  Created by 김용해 on 8/12/25.
//

import SwiftUI
import designSystem

public struct AcceptanceView: View {
    @State private var acceptGroup: (usingAccept: Bool, marketingAccept: Bool) = (false, false)
    @State private var nextPage: Bool = false
    @Environment(\.dismiss) var dismiss
    enum Accept {
        case usingAccept
        case marketingAccept
    }
    var delegate: AuthCoordinatorDelegate?
    
    public init(delegate: AuthCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text("시니어 소개팅에 어서오세요\n새로운 인연을 만나기 전\n동의가 필요해요.")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .lineSpacing(11)
                .tracking(-0.22)
            Spacer()
            
            acceptView("(필수) 이용약관 동의", with: .usingAccept, isClicked: acceptGroup.usingAccept)
            Spacer().frame(height: 24.5)
            acceptView("(선택) 마케팅 정보 수신", with: .marketingAccept, isClicked: acceptGroup.marketingAccept)
            
            Spacer()
            Spacer()
            Spacer()
            
            allAcceptButton()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .navigationTitle("약관 동의")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
    
    private func acceptView(_ title: String, with path: Accept, isClicked: Bool) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18))
                .lineSpacing(9)
                .tracking(-0.54)
            Spacer()
            Group {
                if isClicked {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.black, .yellow)
                }else {
                    Circle()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.Siso.Gray._40)
                }
            }
            .onTapGesture {
                withAnimation(.smooth) {
                    switch path {
                        case .usingAccept:
                            self.acceptGroup.usingAccept.toggle()
                        case .marketingAccept:
                            self.acceptGroup.marketingAccept.toggle()
                    }
                }
            }
        }
    }
    
    private func allAcceptButton() -> some View {
        let isActive: Bool = acceptGroup.usingAccept
        
        return Button(action: {
            delegate?.pushAuth(.welcome)
        }, label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : .gray)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 99))
        })
        .disabled(!isActive)
    }
}

#Preview {
    NavigationStack {
        AcceptanceView(delegate: nil)
    }
}
