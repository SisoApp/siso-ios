//
//  PersonalityProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct PersonalityProfileView: View {
    @ObservedObject var userProfile: UserProfile
    @State private var energy: String = ""
    @State private var information: String = ""
    @State private var decision: String = ""
    @State private var lifeStyle: String = ""
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?, userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack {
            explainView()
            personalityButtonGroup()
            Spacer()
            completeButton()
        }
        .padding()
        .navigationTitle("내 정보 입력")
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
        .onAppear {
            setMBTI()
        }
    }
    
    private func setMBTI() {
        let charArray: [Character] = Array(userProfile.mbti)
        if charArray.count < 4 { return }
        
        energy = charArray[0].description
        information = charArray[1].description
        decision = charArray[2].description
        lifeStyle = charArray[3].description
    }
    
    private func explainView() -> some View {
        return Group {
            Text("나의 성격유형(MBTI)을\n선택해주세요")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("성격유형(MBTI)은 나의 성격을 16가지로\n구분하는 간단한 검사입니다.\n나와 비슷한 성격, 혹은 다른 성격을 가진\n사람을 만나보는 데 도움이 될 수있어요.")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
        }
    }
    
    private func personalityButtonGroup() -> some View {
        return ScrollView {
            VStack {
                HStack(spacing: 0) {
                    leftButton(title: "E", subTitle: "에너지를\n사람 만나서 얻는 편", binding: $energy)
                    seperateLine()
                    rightButton(title: "I", subTitle: "혼자 있을 때\n충전되는 편", binding: $energy)
                }
                
                HStack(spacing: 0) {
                    leftButton(title: "S", subTitle: "눈앞의 사실\n경험 위주로 보는 편", binding: $information)
                    seperateLine()
                    rightButton(title: "N", subTitle: "앞으로의 가능성\n큰 그림을 보는 편", binding: $information)
                }
                
                HStack(spacing: 0) {
                    leftButton(title: "T", subTitle: "이성적·논리적으로\n판단하는 편", binding: $decision)
                    seperateLine()
                    rightButton(title: "F", subTitle: "사람의 마음·관계까지\n고려하는 편", binding: $decision)
                }
                
                HStack(spacing: 0) {
                    leftButton(title: "P", subTitle: "즉흥적이고 유연하게\n풀어가는 편", binding: $lifeStyle)
                    seperateLine()
                    rightButton(title: "J", subTitle: "미리 계획을 세우는 걸\n좋아하는 편", binding: $lifeStyle)
                }
            }
            .padding(.vertical, 30)
        }
    }
    
    private func leftButton(title: String, subTitle: String, binding: Binding<String>) -> some View {
        let isContain: Bool = binding.wrappedValue == title
        
        return VStack {
            Text(title)
                .font(.system(size: 24))
                .fontWeight(.bold)
            Text(subTitle)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background (
            Rectangle()
                .fill(isContain ? Color.Siso.Primary.main : Color.Siso.Gray._20)
                .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))
        )
        .onTapGesture {
            binding.wrappedValue = isContain ? "" : title
        }
    }
    
    private func seperateLine() -> some View {
        return Rectangle()
            .fill(Color.Siso.Gray._40)
            .frame(width: 1, height: 110)
    }
    
    private func rightButton(title: String, subTitle: String, binding: Binding<String>) -> some View {
        let isContain: Bool = binding.wrappedValue == title
        
        return VStack {
            Text(title)
                .font(.system(size: 24))
                .fontWeight(.bold)
            Text(subTitle)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 110)
        .background (
            Rectangle()
                .fill(isContain ? Color.Siso.Primary.main : Color.Siso.Gray._20)
                .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight]))
        )
        .onTapGesture {
            binding.wrappedValue = isContain ? "" : title
        }
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = !energy.isEmpty && !information.isEmpty && !decision.isEmpty && !lifeStyle.isEmpty
        
        return PrimaryButton(title: "완료하기", isActive: isActive) {
            let mbti: String = energy + information + decision + lifeStyle
            userProfile.mbti = mbti
            delegate?.pop()
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        return Path(path.cgPath)
    }
}

#Preview {
    NavigationStack {
        PersonalityProfileView(delegate: nil, userProfile: .empty)
    }
}
