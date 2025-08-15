//
//  BasicProfileView.swift
//  auth
//
//  Created by 멘태 on 8/11/25.
//

import SwiftUI

public struct BasicProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    
    public var delegate: ProfileCoordinatorDelegate?
    
    private var isActive: Bool {
        return !userProfile.nickname.isEmpty &&
                !userProfile.age.isEmpty &&
                !userProfile.sex.isEmpty &&
                !userProfile.targetSex.isEmpty
    }
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(
                currentPage: 1,
                title: "기본 정보를 입력해주세요"
            )
            
            textFieldView(
                field: "닉네임",
                placeholder: "이것은 닉네임입니다.",
                binding: $userProfile.nickname
            )
            
            textFieldView(
                field: "나이",
                placeholder: "나이를 입력해주세요.",
                binding: $userProfile.age
            )
            
            // 라디오 버튼에서 선택한 값을 저장해야함
            
            RadioButtonView(
                title: "내 성별",
                options: ["여성", "남성"],
                binding: $userProfile.sex
            )
            
            RadioButtonView(
                title: "매칭 성별",
                subTitle: "동성 선택시 동성 친구, 이성 선택시 이성 친구를 추천해 드려요.",
                options: ["동성", "이성"],
                binding: $userProfile.targetSex
            )
            
            Spacer()
            
            nextButton()
        }
        .navigationTitle("내 정보 입력")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func textFieldView(field: String, placeholder: String, binding: Binding<String>) -> some View {
        return VStack {
            Text(field)
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ZStack {
                RoundedRectangle(cornerRadius: 27)
                    .fill(Color.Siso.Gray._20)
                    .frame(height: 54)
                
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
            }
        }
        .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
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
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16))
    }
    
    private func nextButton() -> some View {
        return Button {
            delegate?.pushProfile(.interest)
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
        BasicProfileView(delegate: nil, userProfile: .empty)
    }
}
