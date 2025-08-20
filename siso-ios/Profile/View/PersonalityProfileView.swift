//
//  PersonalityProfileView.swift
//  profile
//
//  Created by 멘태 on 8/20/25.
//

import SwiftUI

public struct PersonalityProfileView: View {
    weak var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack {
            Text("나의 성격유형(MBTI)을\n선택해주세요")
                .font(.system(size: 24))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("성격유형(MBTI)은 나의 성격을 16가지로\n구분하는 간단한 검사입니다.\n나와 비슷한 성격, 혹은 다른 성격을 가진\n사람을 만나보는 데 도움이 될 수있어요.")
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 4)
            
            ScrollView {
                personalityButtonStack()
            }
            
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
    }
    
    private func personalityButtonStack() -> some View {
        return VStack {
            HStack(spacing: 0) {
                VStack {
                    Text("E")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("에너지를\n사람 만나서 얻는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Gray._20)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))
                )
                
                Rectangle()
                    .fill(Color.Siso.Gray._40)
                    .frame(width: 1, height: 110)
                
                VStack {
                    Text("I")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("혼자 있을 때\n충전되는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Primary.main)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight]))
                )
            }
            
            HStack(spacing: 0) {
                VStack {
                    Text("S")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("눈앞의 사실\n경험 위주로 보는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Primary.main)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))
                )
                
                Rectangle()
                    .fill(Color.Siso.Gray._40)
                    .frame(width: 1, height: 110)
                
                VStack {
                    Text("N")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("앞으로의 가능성\n큰 그림을 보는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Gray._20)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight]))
                )
            }
            
            HStack(spacing: 0) {
                VStack {
                    Text("T")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("이성적·논리적으로\n판단하는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Gray._20)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))
                )
                
                Rectangle()
                    .fill(Color.Siso.Gray._40)
                    .frame(width: 1, height: 110)
                
                VStack {
                    Text("F")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("사람의 마음·관계까지\n고려하는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Primary.main)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight]))
                )
            }
            
            HStack(spacing: 0) {
                VStack {
                    Text("P")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("즉흥적이고 유연하게\n풀어가는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Primary.main)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .bottomLeft]))
                )
                
                Rectangle()
                    .fill(Color.Siso.Gray._40)
                    .frame(width: 1, height: 110)
                
                VStack {
                    Text("J")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                    Text("미리 계획을 세우는 걸\n좋아하는 편")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 110)
                .background (
                    Rectangle()
                        .fill(Color.Siso.Gray._20)
                        .clipShape(RoundedCorner(radius: 16, corners: [.topRight, .bottomRight]))
                )
            }
        }
        .padding(.vertical, 30)
    }
    
    private func completeButton() -> some View {
        let isActive: Bool = true
        
        return Button {
            delegate?.pushProfile(.interest)
        } label: {
            Text("완료하기")
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
        PersonalityProfileView(delegate: nil)
    }
}
