//
//  ProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public enum ProfileMode {
    case signUp, edit
}

public struct ProfileView: View {
    @ObservedObject var userProfile: UserProfile
    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var introduce: String = ""
    @State private var sex: String = ""
    @State private var targetSex: String = ""
    @State private var isPlaying: Bool = false
    @State private var religion: String = ""
    @State private var meetings: [String] = []
    
    @FocusState private var ageFocus: Bool
    @FocusState private var introduceFocus: Bool
    
    private let viewModel: ProfileViewModel = .init()
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
        self._nickname = State(wrappedValue: userProfile.nickname)
        self._age = State(wrappedValue: userProfile.age)
        self._introduce = State(wrappedValue: userProfile.introduce)
        self._sex = State(wrappedValue: userProfile.sex)
        self._targetSex = State(wrappedValue: userProfile.targetSex)
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack {
                    profileImage()
                    nicknameView()
                    ageView()
                    introduceView()
                    basicInfoSection()
                    additionalInfoSection()
                    tagSection()
                }
                .padding()
                .onTapGesture {
                    hideKeyboard()
                }
                
            }
            completeButton()
        }
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
            HStack {
                textFieldView(title: "나이", unit: "세", binding: $age, isFocused: $ageFocus)
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
  
            recordView()
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.Siso.Gray._20)
                    .stroke(introduceFocus ? Color.Siso.Primary._60 : .clear)
                    .frame(height: 195)
                
                TextEditor(text: $introduce)
                    .focused($introduceFocus)
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
    
    private func recordView() -> some View {
        return HStack {
            HStack {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 15, height: 15)
                    .onTapGesture {
                        isPlaying.toggle()
                    }
                
                waveFormView(count: 30, height: 44)
                
                Text("00:15")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 44 / 2)
                    .fill(Color.Siso.Gray._60)
            )
            
            Image("pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .onTapGesture {
                    delegate?.pushProfile(.voice)
                }
        }
        .padding(.top, 8)
    }
    
    private func waveFormView(count: Int, height: CGFloat) -> some View {
        let randomFactors: [(offset: Double, speed: Double)] = (0..<count).map { _ in
            (offset: Double.random(in: 0...(.pi * 2)),
             speed: Double.random(in: 0.5...1.5))
        }
        
        return TimelineView(.animation(minimumInterval: 0.016)) { timeline in
            HStack(spacing: 4) {
                ForEach(0..<count, id: \.self) { index in
                    
                    let heightRatio: CGFloat = {
                        if isPlaying {
                            let now = timeline.date.timeIntervalSinceReferenceDate
                            let factor = randomFactors[index]
                            let sinValue = sin(now * factor.speed + factor.offset)
                            return (sinValue + 1) / 2
                        } else {
                            return 0.1
                        }
                    }() // 클로저를 정의하고 바로 실행하여 값을 할당

                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 3, height: height * heightRatio)
                        .cornerRadius(4)
                }
            }
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: isPlaying)
        }
        .frame(height: height)
    }
    
    private func basicInfoSection() -> some View {
        return VStack {
            sectionHeader(title: "기본 정보", point: "+ 30%")
            RadioButtonView(title: "내 성별", options: ["여성", "남성"], binding: $sex)
                .padding(.top, 16)
            RadioButtonView(title: "매칭 성별", options: ["이성", "동성", "상관없음"], binding: $targetSex)
                .padding(.top, 16)
            
            inputView(title: "지역", item: userProfile.location)
                .onTapGesture {
                    delegate?.pushProfile(.location)
                }
        }
    }
    
    private func additionalInfoSection() -> some View {
        return VStack {
            sectionHeader(title: "추가 정보", point: "+ 30%")
            
            inputView(title: "종교", item: userProfile.religion)
                .onTapGesture {
                    delegate?.pushProfile(.religion)
                }
            
            inputView(title: "흡연", item: userProfile.smoking)
                .onTapGesture {
                    delegate?.pushProfile(.smoke)
                }
            
            inputView(title: "음주", item: userProfile.drinking)
                .onTapGesture {
                    delegate?.pushProfile(.drink)
                }
            
            inputView(title: "MBTI", item: userProfile.mbti)
                .onTapGesture {
                    delegate?.pushProfile(.personality)
                }
        }
    }
    
    private func tagSection() -> some View {
        return VStack {
            sectionHeader(title: "관심사 / 취향 태그", point: "+ 30%")
            
            tagView(title: "나의 관심사", placeholder: "나의 관심사를 골라주세요", items: userProfile.interests)
                .onTapGesture {
                    delegate?.pushProfile(.interest)
                }
            
            tagView(title: "매칭 상대와의 관계", placeholder: "어떤 관계를 원하시나요?", items: userProfile.meeting)
                .onTapGesture {
                    delegate?.pushProfile(.meeting)
                }
        }
    }
    
    private func tagView(title: String, placeholder: String, items: [String]) -> some View {
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
            
            Group {
                if items.count == 0 {
                    placeholderView(placeholder)
                } else {
                    tagListView(items)
                }
            }
        }
        .padding(.top, 24)
    }
    
    private func placeholderView(_ placeholder: String) -> some View {
        return HStack {
            Text(placeholder)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._70)
                .padding()
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.Siso.Gray._20)
                )
            Spacer()
        }
    }
    
    private func tagListView(_ items: [String]) -> some View {
        return TagGroup {
            ForEach(items, id: \.self) { item in
                tagButton(item)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func tagButton(_ title: String) -> some View {
        return Text(title)
            .padding(EdgeInsets(top: 8, leading: 18, bottom: 8, trailing: 18))
            .frame(height: 48)
            .fontWeight(.semibold)
            .foregroundStyle(Color.Siso.Gray._90)
            .background(Color.Siso.Gray._20)
            .clipShape(.rect(cornerRadius: 24))
    }
    
    private func textFieldView(title: String, unit: String, binding: Binding<String>, isFocused: FocusState<Bool>.Binding) -> some View {
        return VStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                TextField("", text: binding)
                    .focused(isFocused)
                    .keyboardType(.numberPad)
                    .padding()
                    .frame(width: 80, height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 54 / 2)
                            .fill(Color.Siso.Gray._20)
                            .stroke(isFocused.wrappedValue ? Color.Siso.Primary._60 : .clear)
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
    
    private func inputView(title: String, item: String) -> some View {
        return VStack {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, alignment: .leading)
            inputButton(item)
        }
        .padding(.top, 24)
    }
    
    private func inputButton(_ item: String) -> some View {
        let placeholder: String = "정보를 입력해주세요"
        let isActive: Bool = !item.isEmpty
        
        return HStack {
            Text(isActive ? item : placeholder)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(isActive ? Color.Siso.Gray._90 : Color.Siso.Gray._50)
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(height: 52)
        .background(Color.Siso.Gray._20)
        .clipShape(.rect(cornerRadius: 52 / 2))
    }
    
    private func completeButton() -> some View {
        return Button {
            userProfile.age = age
            userProfile.introduce = introduce
            userProfile.sex = sex
            userProfile.targetSex = targetSex
            
            Task {
                await viewModel.registerProfile(userProfile)
            }
            
            delegate?.pop()
        } label: {
            Text("완료하기")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
        }
        .frame(height: 54)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
    
    private func hideKeyboard() {
        ageFocus = false
        introduceFocus = false
    }
}


#Preview {
    NavigationStack {
        ProfileView(delegate: nil, userProfile: .empty)
    }
}
