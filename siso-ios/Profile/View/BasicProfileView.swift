//
//  BasicProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

public struct BasicProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    
    @Binding private var currentPage: SignUpProfilePage
    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var sex: String = ""
    @State private var targetSex: String = ""
    
    @FocusState private var nicknameFocus: Bool
    @FocusState private var ageFocus: Bool
    
    private var isActive: Bool {
        return !nickname.isEmpty && !age.isEmpty &&
                !sex.isEmpty && !targetSex.isEmpty
    }
    
    private var isScroll: Bool {
        return nicknameFocus || ageFocus
    }
    
    public init(currentPage: Binding<SignUpProfilePage>, userProfile: UserProfile) {
        self._currentPage = currentPage
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 0) {
                    informationText()
                    
                    textFieldView(field: "닉네임", placeholder: "이것은 닉네임입니다.", binding: $nickname, isFocused: nicknameFocus)
                        .focused($nicknameFocus)
                        .submitLabel(.done)
                        .onChange(of: nickname) { _, newValue in
                            nickname = String(newValue.prefix(8))
                        }
                        .onSubmit {
                            ageFocus = true
                            nicknameFocus = false
                        }
                    
                    textFieldView(field: "나이", placeholder: "나이를 입력해주세요.", binding: $age, isFocused: ageFocus)
                        .focused($ageFocus)
                        .keyboardType(.numbersAndPunctuation)
                        .submitLabel(.done)
                        .onChange(of: age) { _, newValue in
                            let filtered: String = newValue.filter { "0123456790".contains($0) }
                            age = String(filtered.prefix(2))
                        }
                        .onSubmit {
                            hideKeyboard()
                        }
                    RadioButtonView(title: "내 성별", options: ["여성", "남성"], binding: $sex)
                    
                    RadioButtonView(
                        title: "매칭 성별",
                        subTitle: "동성 선택시 동성 친구, 이성 선택시 이성 친구를 추천해 드려요.",
                        options: ["동성", "이성"],
                        binding: $targetSex
                    )
                }
                .onTapGesture {
                    nicknameFocus = false
                    ageFocus = false
                }
            }
            .scrollDisabled(!isScroll)
            
            Spacer()
            nextButton()
        }
        .padding(.top, 60)
        .padding(.horizontal)
        .background(.white)
    }
    
    private func informationText() -> some View {
        return Text("기본 정보를 입력해주세요")
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func textFieldView(field: String, placeholder: String, binding: Binding<String>, isFocused: Bool) -> some View {
        return VStack {
            Text(field)
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
                HStack {
                    TextField(placeholder, text: binding)
                        .frame(height: 48)
                        .padding(.horizontal, 16)
                    
                    Image("pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24)
                        .padding(.trailing, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: 54 / 2)
                        .fill(Color.Siso.Gray._20)
                        .stroke(isFocused ? Color.Siso.Primary._60 : .clear)
                        .frame(height: 54)
                )
        }
        .padding(.top, 24)
    }
    
    private func RadioButtonView(title: String, subTitle: String? = nil, options: [String], binding: Binding<String>) -> some View {
        return VStack(spacing: 0) {
            Text(title)
                .padding(.top, 16)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
            
            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    let isSelect: Bool = binding.wrappedValue == option
                    
                    HStack(spacing: 0) {
                        Text(option)
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
                        binding.wrappedValue = option
                    }
                }
                
                Spacer()
            }
        }
        .padding(.top)
    }
    
    private func nextButton() -> some View {
        return Button {
            userProfile.nickname = nickname
            userProfile.age = age
            userProfile.sex = sex
            userProfile.targetSex = targetSex
            
            currentPage = .image
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
        .disabled(!isActive)
        .frame(height: 54)
        .padding(.bottom, 8)
    }
    
    private func hideKeyboard() {
        nicknameFocus = false
        ageFocus = false
    }
}

#Preview {
    NavigationStack {
        BasicProfileView(currentPage: .constant(.basic), userProfile: .empty)
    }
}
