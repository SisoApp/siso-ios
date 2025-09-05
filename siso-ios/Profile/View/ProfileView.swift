//
//  ProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI
import model

public enum ProfileMode {
    case signUp, edit
}

public struct ProfileView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject var userProfile: UserProfile
    @ObservedObject private var viewModel: ProfileViewModel = .init()
    
    @State private var nickname: String = ""
    @State private var age: String = ""
    @State private var introduce: String = ""
    @State private var sex: String? = nil
    @State private var targetSex: String? = nil
    @State private var religion: String = ""
    @State private var meetings: [String] = []
    @State private var interests: [String] = []
    @State private var showAlert: Bool = false
    @State private var didInit: Bool = false
    
    @FocusState private var ageFocus: Bool
    @FocusState private var introduceFocus: Bool
    
    
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack {
                    profileImageView()
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
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("완료") {
                    hideKeyboard()
                }
                .foregroundStyle(Color.Siso.Gray._90)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.setViewModel()
            await MainActor.run {
                if !didInit {
                    bindViewValue()
                    didInit = true
                }
            }
        }
    }
    
    private func profileImageView() -> some View {
        return ZStack(alignment: .bottomTrailing) {
            Group {
                if let image = viewModel.images?[0],
                   let imageUrl = URL(string: image.presignedUrl) {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            
                    } placeholder: {
                        Image("Camera")
                            .resizable()
                            .scaledToFit()
                            .padding(32)
                    }
                } else {
                    Image("Camera")
                        .resizable()
                        .scaledToFit()
                        .padding(32)
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(.rect(cornerRadius: 120 / 2))
            .onTapGesture {
                delegate?.pushProfile(.image)
            }
            
            Image("pencil")
                .resizable()
                .scaledToFit()
                .padding(4)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(Color.Siso.Gray._20)
                        .stroke(Color.Siso.Gray._5, lineWidth: 3)
                )
        }
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
            
            Text(nickname)
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
                    .keyboardType(.numbersAndPunctuation)
                    .submitLabel(.done)
                    .onChange(of: age) { _, newValue in
                        let filtered: String = newValue.filter { "0123456790".contains($0) }
                        age = String(filtered.prefix(2))
                    }
                    .onSubmit {
                        hideKeyboard()
                    }
                    
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
            textView()
        }
    }
    
    private func textView() -> some View {
        return ZStack {
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
                .onChange(of: introduce) { _, newValue in
                    introduce = newValue.prefix(50).description
                }
            
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
    
    private func recordView() -> some View {
        return HStack {
            HStack {
                Image(systemName: viewModel.status == .playing ? "pause.fill" : "play.fill")
                    .resizable()
                    .foregroundStyle(.white)
                    .frame(width: 15, height: 15)
                    .onTapGesture {
                        if viewModel.status == .playing {
                            viewModel.stopPlaying()
                        } else if viewModel.status == .waiting {
                            viewModel.startPlaying()
                        }
                    }
                
                waveFormView(count: 30, height: 44)
                
                Text("00:\(viewModel.voiceTimeText)")
                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .frame(minWidth: 60)
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 44 / 2)
                    .fill(Color.Siso.Gray._60)
            )
            
            Button {
                delegate?.pushProfile(.voice)
            } label: {
                Text("수정")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.Siso.Gray._60)
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
                        if viewModel.status == .playing {
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
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: viewModel.status)
        }
        .frame(height: height)
    }
    
    private func basicInfoSection() -> some View {
        return VStack {
            sectionHeader(title: "기본 정보", point: "+ 30%")
            
            RadioButtonGroup(title: "내 성별", options: viewModel.sexOptions, selection: $sex)
                .padding(.top)
            
            RadioButtonGroup(title: "매칭 성별", options: viewModel.preferenceSexOptions, selection: $targetSex)
                .padding(.top)
            
            inputView(title: "지역", item: userProfile.location)
                .onTapGesture {
                    delegate?.pushProfile(.location)
                }
        }
    }
    
    private func additionalInfoSection() -> some View {
        return VStack {
            sectionHeader(title: "추가 정보", point: "+ 30%")
            
            inputView(title: "종교", item: viewModel.getReligionDescription(for: userProfile.religion))
                .onTapGesture {
                    delegate?.pushProfile(.religion)
                }
            
            inputView(title: "흡연", item: viewModel.smokeDescription)
                .onTapGesture {
                    delegate?.pushProfile(.smoke)
                }
            
            inputView(title: "음주", item: viewModel.getDrinkingCapacityDescription(for: userProfile.drinking))
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
            
            tagView(title: "나의 관심사",
                    placeholder: "나의 관심사를 골라주세요",
                    items: viewModel.getInterestDescriptions(for: userProfile.interests))
                .onTapGesture {
                    delegate?.pushProfile(.interest)
                }
            
            tagView(title: "매칭 상대와의 관계",
                    placeholder: "어떤 관계를 원하시나요?",
                    items: viewModel.getMettingDescriptions(for: userProfile.meeting))
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
        return PrimaryButton(title: "완료하기") {
            guard let sex = sex, let targetSex = targetSex else { return }
            guard introduce.count >= 5 || introduce.count == 0 else {
                showAlert = true
                return
            }
            
            userProfile.nickname = nickname
            userProfile.age = Int(age) ?? 0
            userProfile.introduce = introduce
            userProfile.sex = sex
            userProfile.targetSex = targetSex
            
            Task {
                do {
                    try await viewModel.updateWholeProfile(userProfile)
                    delegate?.pop()
                } catch {
                    
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .alert("오류", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text("자기소개를 5자 이상 작성해주세요")
        }
    }
    
    private func hideKeyboard() {
        ageFocus = false
        introduceFocus = false
    }
    
    private func bindViewValue() {
        nickname = viewModel.profile?.nickname ?? ""
        age = viewModel.profile?.age.description ?? ""
        introduce = viewModel.profile?.introduce ?? ""
        sex = viewModel.profile?.sex?.rawValue
        targetSex = viewModel.profile?.preferenceSex?.rawValue
        
        religion = viewModel.profile?.religion?.rawValue ?? ""
        userProfile.religion = viewModel.profile?.religion?.rawValue ?? ""
        
        userProfile.smoking = viewModel.smoke
        userProfile.mbti = viewModel.profile?.mbti?.rawValue ?? ""
        userProfile.drinking = viewModel.profile?.drinkingCapacity?.rawValue ?? ""
        
        userProfile.location = viewModel.profile?.location ?? ""
        
        meetings = viewModel.profile?.meetings?.map { $0.rawValue } ?? []
        userProfile.meeting = viewModel.profile?.meetings?.map { $0.rawValue } ?? []
        
        interests = viewModel.interests?.map { $0.rawValue } ?? []
        userProfile.interests = viewModel.interests?.map { $0.rawValue } ?? []
    }
}


#Preview {
    NavigationStack {
        ProfileView(delegate: nil, userProfile: .empty)
    }
}
