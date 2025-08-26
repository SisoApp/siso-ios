//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI
import designSystem

public struct ImageProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @Binding var currentPage: SignUpProfilePage
    private var images: [UIImage] = [] // 이미지 등록을 건너뛸 때 초기 값으로 복구하기 위한 초기값 저장 변수
    
    weak var delegate: ProfileCoordinatorDelegate?
    private let limit: Int = 5
    
    public init(delegate: ProfileCoordinatorDelegate?,
                currentPage: Binding<SignUpProfilePage>,
                userProfile: UserProfile) {
        self.delegate = delegate
        self._currentPage = currentPage
        self.userProfile = userProfile
        self.images = userProfile.profileImageUrl
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            informationText()
            mainImageView()
            subImageView()
            Spacer()
            addButton()
            bottomButton()
        }
        .padding(.top, 60)
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        currentPage = .basic
                    }
            }
        }
    }
    
    private func informationText() -> some View {
        return Group {
            Text("나를 표현하는 사진을 보여주세요")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("최소 1장 이상 선택해주세요\n정보는 나중에 수정할 수 있어요")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.Siso.Gray._60)
                .lineSpacing(9)
                .padding(.top, 8)
        }
    }
    
    private func mainImageView() -> some View {
        let index: Int = 0
        let isExist: Bool = userProfile.profileImageUrl.count > index
        
        return ZStack(alignment: .topTrailing) {
            Group {
                if isExist {
                    Image(uiImage: userProfile.profileImageUrl[index])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 206)
                        .background(Color.Siso.Gray._20)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 12))
                    Button {
                        userProfile.profileImageUrl.remove(at: index)
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                            .frame(width: 28, height: 28)
                            .foregroundStyle(Color.Siso.Gray._60)
                            .background(Color.Siso.Gray._20)
                            .clipShape(.rect(cornerRadius: 14))
                            .clipped()
                            .offset(y: -9)
                            .overlay {
                                Circle()
                                    .stroke(Color.Siso.Gray._5, lineWidth: 3)
                                    .offset(y: -9)
                            }
                    }
                } else {
                    Image("Camera")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .scaledToFit()
                        .frame(height: 206)
                        .frame(maxWidth: .infinity)
                        .background(Color.Siso.Gray._20)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.top, 44)
        }
    }
    
    private func subImageView() -> some View {
        let size =  (UIScreen.main.bounds.width - (8 * 3 + 16 * 2)) / 4
        
        return HStack(spacing: 8) {
            ForEach(1...4, id: \.self) { index in
                let isExist: Bool =
                userProfile.profileImageUrl.count > index
                
                ZStack(alignment: .topTrailing) {
                    Group {
                        if isExist {
                            Image(uiImage: userProfile.profileImageUrl[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: size, height: size)
                                .background(Color.Siso.Gray._20)
                                .clipped()
                                .clipShape(.rect(cornerRadius: 12))
                            
                            Button {
                                userProfile.profileImageUrl.remove(at: index)
                            } label: {
                                Image(systemName: "xmark")
                                    .fontWeight(.bold)
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(Color.Siso.Gray._60)
                                    .background(Color.Siso.Gray._20)
                                    .clipShape(.rect(cornerRadius: 14))
                                    .clipped()
                                    .offset(y: -9)
                                    .overlay {
                                        Circle()
                                            .stroke(Color.Siso.Gray._5, lineWidth: 3)
                                            .offset(y: -9)
                                    }
                            }
                        } else {
                            Image("Camera")
                                .frame(width: size, height: size)
                                .background(Color.Siso.Gray._20)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func addButton() -> some View {
        let isActive: Bool = userProfile.profileImageUrl.count >= 0 && userProfile.profileImageUrl.count < 5
        
        return Button {
            delegate?.presentProfile(sheet: .imageHelper({ images in
                delegate?.dismissProfileSheet()
                userProfile.profileImageUrl.append(contentsOf: images)
            }))
        } label: {
            Text("사진 추가하기 (\(userProfile.profileImageUrl.count)/\(limit))")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(isActive ? Color.Siso.Primary.main : Color.Siso.Gray._20)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .padding(.vertical, 8)
        .disabled(!isActive)
    }
    
    private func bottomButton() -> some View {
        return Group {
            if userProfile.profileImageUrl.count > 0 {
                nextButton()
            } else {
                skipButton()
            }
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = userProfile.profileImageUrl.count > 0
        
        return Button {
            currentPage = .introduce
        } label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
    }
    
    private func skipButton() -> some View {
        return Button {
            userProfile.profileImageUrl = images // 정보 갱신 x, 초기 값으로 복구
            currentPage = .introduce
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
        ImageProfileView(delegate: nil, currentPage: .constant(.image) , userProfile: .empty)
    }
}
