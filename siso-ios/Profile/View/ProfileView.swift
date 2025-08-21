//
//  ProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct ProfileView: View {
    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var introduce: String = ""
    @State private var height: String = ""
    @State private var sex: String = ""
    @State private var target: String = ""
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        ScrollView {
            VStack {
                profileImage()
                nicknameView()
                ageView()
                introduceView()
                basicInfoSection()
                additionalInfoSection()
                tagSection()
                
                Spacer()
            }
            .padding()
            .navigationTitle("내 정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
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
    }
    
    private func profileImage() -> some View {
        return Image("testimg")
            .resizable()
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipped()
            .clipShape(.rect(cornerRadius: 60))
            .padding(.top, 10)
    }
    
    private func sectionHeader(title: String, point: String) -> some View {
        return HStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            Text(point)
                .font(.system(size: 18, weight: .semibold))
                .padding(EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8))
                .background(Color.Siso.Primary._40)
                .clipShape(.rect(cornerRadius: 8))
        }
        .padding(.top, 40)
    }
    
    private func nicknameView() -> some View {
        return VStack {
            Text("닉네임")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("닉네임입니다")
                .font(.system(size: 24, weight: .bold))
                .padding()
                .frame(height: 54)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 54 / 2)
                        .fill(Color.Siso.Gray._20)
                )
        }
        .padding(.top)
    }
    
    private func ageView() -> some View {
        return VStack {
            Text("나이")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Text("50")
                    .font(.system(size: 24, weight: .bold))
                    .padding()
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 54 / 2)
                            .fill(Color.Siso.Gray._20)
                    )
                Text("세")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.Siso.Gray._50)
                Spacer()
            }
        }
        .padding(.top)
    }
    
    private func introduceView() -> some View {
        return VStack {
            Text("자기소개")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .padding(.top)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Siso.Gray._60)
                    .padding(.trailing, 8)
                    .frame(height: 44)
                
                Image("pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .offset(x: -5)
            }
            .padding(.top)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Siso.Gray._20)
                    
                    .frame(height: 195)
                
                TextEditor(text: $introduce)
                    .background(.clear)
                    .scrollContentBackground(.hidden)
                    .font(.system(size: 20, weight: .semibold))
                    .padding()
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("\(introduce.count)/50")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.Siso.Gray._50)
                    }
                }
                .padding()
            }
            .padding(.top)
        }
    }
    
    private func basicInfoSection() -> some View {
        return VStack {
            sectionHeader(title: "기본 정보", point: "+ 30%")
            
            textFieldView(title: "키", unit: "cm")
                .padding(.top, 16)
            textFieldView(title: "몸무게", unit: "kg")
                .padding(.top, 8)
            RadioButtonView(title: "내 성별", options: ["여성", "남성"], binding: $sex)
                .padding(.top, 16)
            RadioButtonView(title: "매칭 성별", options: ["이성", "동성", "상관없음"], binding: $target)
                .padding(.top, 16)
            
            inputView(title: "지역", placeholder: "나의 지역을 등록해주세요")
                .onTapGesture {
                    delegate?.pushProfile(.location)
                }
        }
    }
    
    private func additionalInfoSection() -> some View {
        return VStack {
            sectionHeader(title: "추가 정보", point: "+ 30%")
            
            inputView(title: "종교", placeholder: "정보를 입력해주세요")
                .onTapGesture {
                    delegate?.pushProfile(.religion)
                }
            
            inputView(title: "흡연", placeholder: "정보를 입력해주세요")
                .onTapGesture {
                    delegate?.pushProfile(.smoke)
                }
            
            inputView(title: "음주", placeholder: "정보를 입력해주세요")
                .onTapGesture {
                    delegate?.pushProfile(.drink)
                }
            
            inputView(title: "MBTI", placeholder: "정보를 입력해주세요")
                .onTapGesture {
                    delegate?.pushProfile(.personality)
                }
        }
    }
    
    private func tagSection() -> some View {
        return VStack {
            sectionHeader(title: "관심사 / 취향 태그", point: "+ 30%")
            
            tagView(title: "나의 관심사", placehorder: "나의 관심사를 골라주세요")
                .onTapGesture {
                    delegate?.pushProfile(.interest)
                }
            
            tagView(title: "매칭 상대와의 관계", placehorder: "어떤 관계를 원하시나요?")
                .onTapGesture {
                    delegate?.pushProfile(.meeting)
                }
        }
    }
    
    private func tagView(title: String, placehorder: String) -> some View {
        return VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.Siso.Gray._50)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color.Siso.Gray._50)
            }
            
            HStack {
                Button {
                    
                } label: {
                    Text(placehorder)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.Siso.Gray._70)
                }
                .padding()
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.Siso.Gray._20)
                )
                Spacer()
            }
        }
        .padding(.top, 24)
    }
    
    private func textFieldView(title: String, unit: String) -> some View {
        return VStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                TextField("", text: $height)
                    .padding()
                    .frame(width: 80, height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 54 / 2)
                            .fill(Color.Siso.Gray._20)
                    )
                Text(unit)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.Siso.Gray._50)
                Spacer()
            }
        }
    }
    
    private func RadioButtonView(title: String, options: [String], binding: Binding<String>) -> some View {
        return VStack {
            Text(title)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack() {
                ForEach(options, id: \.self) { option in
                    let isSelect: Bool = binding.wrappedValue == option
                    
                    HStack(spacing: 2) {
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
                    .onTapGesture {
                        binding.wrappedValue = option
                    }
                }
                .padding(.top, 4)
                
                Spacer()
            }
        }
    }
    
    private func inputView(title: String, placeholder: String) -> some View {
        return VStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            inputButton(placeholder)
        }
        .padding(.top, 24)
    }
    
    private func inputButton(_ placeholder: String) -> some View {
        return HStack {
            Text(placeholder)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(height: 52)
        .background(Color.Siso.Gray._20)
        .clipShape(.rect(cornerRadius: 52 / 2))
    }
}

#Preview {
    NavigationStack {
        ProfileView(delegate: nil)
    }
}
