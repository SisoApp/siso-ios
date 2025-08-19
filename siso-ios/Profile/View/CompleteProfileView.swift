//
//  FinishProfileView.swift
//  profile
//
//  Created by 멘태 on 8/16/25.
//

import SwiftUI

public struct CompleteProfileView: View {
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        ZStack {
            Image("bgprofile")
                .resizable()
                .scaledToFill()
            
            VStack {
                Spacer()
                
                Text("내 정보 입력을 완료하였습니다!\n시팅에서 나와 취향이 같은\n인연을 더 잘 만날 수 있어요")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                
                completeButton()
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("내 정보 입력")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        delegate?.pop()
                    }
            }
        }
    }
    
    private func completeButton() -> some View {
        return Button {
            delegate?.changeProfileToMatching()
        } label: {
            Text("인연 만나기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
        }
    }
}

#Preview {
    NavigationStack {
        CompleteProfileView(delegate: nil)
    }
}
