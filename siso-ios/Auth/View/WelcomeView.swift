//
//  WelcomeView.swift
//  auth
//
//  Created by 김용해 on 8/13/25.
//

import SwiftUI
import designSystem

public struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    var delegate: AuthCoordinatorDelegate?
    
    public init(delegate: AuthCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Spacer()
            Text("시팅 가입을 환영합니다\n내정보를 입력하면\n좋은 인연을 만날 확률이 높아져요")
                .font(.system(size: 22))
                .fontWeight(.semibold)
                .lineSpacing(11)
                .tracking(-0.22)
                .padding()
            Spacer()
            Spacer()
            Image("WelcomeVector")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .offset(y: 10)
            Spacer()
            allAcceptButton()
                .padding()
        }
        .frame(maxWidth: .infinity)
        .navigationTitle("내 정보 입력")
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
    
    private func allAcceptButton() -> some View {
        Button(action: {
            delegate?.changeAuthToProfile()
        }, label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 99))
        })
    }
}

#Preview {
    NavigationStack {
        WelcomeView(delegate: nil)
    }
}
