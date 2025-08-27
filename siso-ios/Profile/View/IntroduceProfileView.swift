//
//  IntroduceProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI

public struct IntroduceProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @FocusState private var isFocused: Bool
    @Binding var currentPage: SignUpProfilePage
    @State private var introduce: String
    
    public init(currentPage: Binding<SignUpProfilePage>, userProfile: UserProfile) {
        self._currentPage = currentPage
        self.userProfile = userProfile
        self._introduce = State(wrappedValue: userProfile.introduce)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    informationText()
                    introduceTextEditorView()
                    countView()
                    Color.clear.frame(height: 1).id("bottom")
                }
                .onChange(of: isFocused) { oldValue, newValue in
                    if newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                    }
                }
            }
            nextButton()
            
            if !isFocused {
                skipButton()
            }
        }
        .scrollDisabled(!isFocused)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        currentPage = .image
                    }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    isFocused = false
                }
                .foregroundStyle(Color.Siso.Gray._90)
            }
        }
        .padding(.horizontal)
    }
    
    private func informationText() -> some View {
        return Group {
            Text("간단한 자기소개를 작성해주세요")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 60)
                .padding(.bottom, 8)
            
            Text("여러분의 진솔한 생각과 경험을 담아\n상대방이 당신을 더 잘 이해할 수 있도록\n5자 이상, 50자 이하로 작성해주세요\n정보는 다음에 수정할 수 있어요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.Siso.Gray._60)
                .lineSpacing(9)
            
        }
        .onTapGesture {
            isFocused = false
        }
    }
    
    private func introduceTextEditorView() -> some View {
        return ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.Siso.Gray._20)
                .stroke(isFocused ? Color.Siso.Primary._60 : .clear)
                .frame(height: 206)
            
            if introduce.isEmpty && !isFocused {
                Text("예시) 안녕하세요. 인생의 황혼기에 접어 들었지만 늘 새로운 경험과 사랑을 찾아 나아가고 있습니다.")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.Siso.Gray._50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            TextEditor(text: $introduce)
                .focused($isFocused)
                .font(.system(size: 18))
                .tint(.gray)
                .background(.clear)
                .scrollContentBackground(.hidden)
                .padding()
                .onChange(of: introduce) { _, newValue in
                    introduce = newValue.prefix(50).description
                }
                
        }
        .padding(.top, 24)
    }
    
    private func countView() -> some View {
        return HStack {
            Spacer()
            Text("\(introduce.count)/50")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._50)
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = introduce.count >= 5
        
        return Button {
            userProfile.introduce = introduce
            currentPage = .voice
        } label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(isActive ? .black : Color.Siso.Gray._50)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._30)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .frame(height: 54)
        .disabled(!isActive)
        .padding(.vertical, 8)
    }
    
    private func skipButton() -> some View {
        return Button {
            currentPage = .voice
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 54)
    }
}

#Preview {
    NavigationStack {
        IntroduceProfileView(currentPage: .constant(.introduce), userProfile: .empty)
    }
}
