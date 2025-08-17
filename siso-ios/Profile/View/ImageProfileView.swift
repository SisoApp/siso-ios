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
    
    weak var delegate: ProfileCoordinatorDelegate?
    private let maxCount: Int = 5
    
    public init(delegate: ProfileCoordinatorDelegate?,
                userProfile: UserProfile) {
        self.delegate = delegate
        self.userProfile = userProfile
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ProfileHeaderView(
                currentPage: 3,
                title: "나를 표현하는 사진을 보여주세요",
                subTitle: "최소 1장 이상 선택해주세요\n정보는 나중에 수정할 수 있어요"
            )
            
            mainImageView()
            subImageView()
            
            Spacer()
            
            addButton()
            
            Group {
                if userProfile.profileImageUrl.count > 0 {
                    nextButton()
                } else {
                    skipButton()
                }
            }
        }
        .navigationTitle("내 정보 입력")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
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
                            .overlay {
                                Circle().stroke(Color.Siso.Gray._5, lineWidth: 3)
                            }
                    }
                } else {
                    Image("camera")
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
            .padding(EdgeInsets(top: 44, leading: 16, bottom: 0, trailing: 16))
        }
    }
    
    private func subImageView() -> some View {
        return GeometryReader { geo in
            let width =  (geo.size.width - (8 * 3 + 16 * 2)) / 4
            
            HStack(spacing: 8) {
                ForEach(1...4, id: \.self) { index in
                    let isExist: Bool =
                    userProfile.profileImageUrl.count > index
                    
                    ZStack(alignment: .topTrailing) {
                        Group {
                            if isExist {
                                Image(uiImage: userProfile.profileImageUrl[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: width)
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
                                        .overlay {
                                            Circle().stroke(Color.Siso.Gray._5, lineWidth: 3)
                                        }
                                }
                            } else {
                                Image("camera")
                                    .frame(width: width, height: width)
                                    .background(Color.Siso.Gray._20)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
            .padding(.horizontal)
        }
    }
    
    private func addButton() -> some View {
        let isActive: Bool = userProfile.profileImageUrl.count > 0
        
        return Button {
            delegate?.presentProfile(sheet: .imageHelper({ images in
                delegate?.dismissProfileSheet()
                self.userProfile.profileImageUrl = images
            }))
        } label: {
            Text("사진 추가하기 (\(userProfile.profileImageUrl.count)/\(maxCount))")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
                .overlay {
                    RoundedRectangle(cornerRadius: 27)
                        .stroke(
                            Color.Siso.Primary._80,
                            lineWidth: 1
                        )
                }
                .animation(.smooth, value: isActive)
        }
        .padding(.horizontal)
    }
    
    private func nextButton() -> some View {
        let isActive: Bool = userProfile.profileImageUrl.count > 0
        
        return Button {
            delegate?.pushProfile(.introduce)
        } label: {
            Text("계속하기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
                .overlay {
                    RoundedRectangle(cornerRadius: 27)
                        .stroke(
                            Color.Siso.Primary._80,
                            lineWidth: 1
                        )
                }
                .animation(.smooth, value: isActive)
        }
        .disabled(!isActive)
        .padding(.top, 8)
        .padding(.horizontal)
    }
    
    private func skipButton() -> some View {
        return Button {
            delegate?.pushProfile(.introduce)
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(height: 54)
        .padding(.top, 8)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ImageProfileView(delegate: nil, userProfile: .empty)
    }
}
