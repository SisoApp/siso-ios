//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI
import designSystem
import network

public struct ImageProfileView: View {
    @ObservedObject private var userProfile: UserProfile
    @Binding var currentPage: SignUpProfilePage
    private var images: [UIImage] = [] // 이미지 등록을 건너뛸 때 초기 값으로 복구하기 위한 초기값 저장 변수
    
    weak var delegate: ProfileCoordinatorDelegate?
    private let mode: ProfileMode
    private let limit: Int = 5
    
    public init(delegate: ProfileCoordinatorDelegate?,
                currentPage: Binding<SignUpProfilePage>,
                userProfile: UserProfile,
                mode: ProfileMode) {
        self.delegate = delegate
        self._currentPage = currentPage
        self.userProfile = userProfile
        self.images = userProfile.profileImages
        self.mode = mode 
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
        .navigationTitle(mode == .signUp ? "내 정보 등록" : "내 정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.backward")
                    .foregroundStyle(Color.Siso.Gray._90)
                    .onTapGesture {
                        switch mode {
                        case .signUp:
                            currentPage = .basic
                        case .edit:
                            delegate?.pop()
                        }
                    }
            }
        }
        .toolbar(.hidden, for: .tabBar)
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
        let isExist: Bool = userProfile.profileImages.count > index
        
        return ZStack(alignment: .topTrailing) {
            Group {
                if isExist {
                    Image(uiImage: userProfile.profileImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 206)
                        .background(Color.Siso.Gray._20)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 12))
                    Button {
                        userProfile.profileImages.remove(at: index)
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
                userProfile.profileImages.count > index
                
                ZStack(alignment: .topTrailing) {
                    Group {
                        if isExist {
                            Image(uiImage: userProfile.profileImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: size, height: size)
                                .background(Color.Siso.Gray._20)
                                .clipped()
                                .clipShape(.rect(cornerRadius: 12))
                            
                            Button {
                                userProfile.profileImages.remove(at: index)
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
        let isActive: Bool = userProfile.profileImages.count >= 0 && userProfile.profileImages.count < 5
        
        return PrimaryButton(title: "사진 추가하기 (\(userProfile.profileImages.count)/\(limit))", isActive: isActive) {
            delegate?.presentProfile(sheet: .imageHelper({ images in
                delegate?.dismissProfileSheet()
                userProfile.profileImages.append(contentsOf: images)
            }))
        }
        .padding(.vertical, 8)
    }
    
    private func bottomButton() -> some View {
        return Group {
            if userProfile.profileImages.count > 0 {
                nextButton()
            } else {
                skipButton()
            }
        }
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = userProfile.profileImages.count > 0
        
        return PrimaryButton(title: "계속하기", isActive: isActive) {
            Task {
                try await ImageNetworkManager.shared.uploadImages(userProfile.profileImages)
            }
        
            switch mode {
            case .signUp:
                currentPage = .introduce
            case .edit:
                delegate?.pop()
            }
        }
    }
    
    private func skipButton() -> some View {
        let isActive: Bool = mode == .signUp
        
        return Group {
            if isActive {
                Button {
                    userProfile.profileImages = images // 정보 갱신 x, 초기 값으로 복구
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
    }
}

#Preview {
    NavigationStack {
        ImageProfileView(delegate: nil, currentPage: .constant(.image) , userProfile: .empty, mode: .signUp)
    }
}
