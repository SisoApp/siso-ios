//
//  IntroduceProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI

public struct IntroduceProfileView: View {
    @State private var text: String = ""
    var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            ProfileHeaderView(
                currentPage: 4,
                title: "간단한 자기소개를 작성해주세요",
                subTitle: "여러분의 진솔한 생각과 경험을 담아 \n상대방이 당신을 더 잘 이해할 수 있도록\n5자 이상, 50자 이하로 작성해주세요.\n정보는 나중에 수정할 수 있어요"
            )
            
            RoundedRectangle(cornerRadius: 24)
                .fill(.gray.opacity(0.2))
                .frame(height: 206)
                .overlay {
                    TextEditor(text: $text)
                        .background(.clear)
                        .scrollContentBackground(.hidden) // textEditor 배경색 지우기
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .top
                        )
                        .padding()
                }
                .padding(.vertical, 32)
                .padding(.horizontal)
            
            Spacer()
            
            nextButton()
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
    
    private func nextButton() -> some View {
        let isActive: Bool = true
        
        return Button {
            delegate?.pushProfile(.image)
        } label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .overlay {
                    RoundedRectangle(cornerRadius: 27)
                        .stroke(
                            isActive ? Color.Siso.Primary._80 : Color.Siso.Gray._40,
                            lineWidth: 1
                        )
                }
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .padding()
    }
}

#Preview {
    NavigationStack {
        IntroduceProfileView(delegate: nil)
    }
}
