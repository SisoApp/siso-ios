//
//  ImageHelperBottomSheet.swift
//  profile
//
//  Created by 멘태 on 8/14/25.
//

import SwiftUI
import PhotosUI

public struct ImageHelperSheet: View {
    @ObservedObject private var userProfile: UserProfile
    @State private var selectedImages: [PhotosPickerItem] = []
    
    public var delegate: ProfileCoordinatorDelegate?
    public var completion: ([UIImage]) -> Void
    
    public init(delegate: ProfileCoordinatorDelegate?,
                userProfile: UserProfile,
                completion: @escaping (([UIImage]) -> Void)) {
        self.delegate = delegate
        self.userProfile = userProfile
        self.completion = completion
    }
    
    public var body: some View {
        bottomSheet()
            .presentationDetents([.height(498)])
            .presentationCornerRadius(24)
            .onChange(of: selectedImages) { _, items in
                delegate?.dismissProfileSheet()
                
                Task {
                    for item in items {
                        if let data: Data = try? await item.loadTransferable(type: Data.self),
                           let image: UIImage = UIImage(data: data) {
                            await MainActor.run {
                                userProfile.profileImageUrl.append(image)
                            }
                        }
                    }
                }
            }
    }
    
    private func bottomSheet() -> some View {
        return VStack(spacing: 0) {
            HStack {
                Text("사진 업로드 도움말")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
                    .bold()
                    .onTapGesture {
                        delegate?.dismissProfileSheet()
                    }
            }
            .padding(EdgeInsets(top: 38, leading: 16, bottom: 0, trailing: 16))
            
            Text("꼭 얼굴이 아니더라도 내가 관심있는 분야의\n사진을 올려줘도 좋아요\n예시) 반려동물, 꽃, 운동하는 사진, 등산 등")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
                .padding(EdgeInsets(top: 24, leading: 16, bottom: 0, trailing: 16))
            
            HStack {
                imageExample(name: "dog")
                imageExample(name: "flower")
                imageExample(name: "baseball")
            }
            .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
            
            VStack(spacing: 8) {
                cameraButton()
                galleryButton()
                skipButton()
            }
            .padding(EdgeInsets(top: 32, leading: 16, bottom: 0, trailing: 16))
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 12))
    }
    
    private func imageExample(name: String) -> some View {
        return Image(name)
            .resizable()
            .scaledToFit()
    }
    
    private func cameraButton() -> some View {
        return Button {
            delegate?.presentProfile(sheet: .cameraSheet)
        } label: {
            Text("카메라로 사진찍기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
        }
    }
    
    private func galleryButton() -> some View {
        return PhotosPicker(
            selection: $selectedImages,
            maxSelectionCount: 5
        ) {
            Text("앨범에서 가져오기")
                .frame(maxWidth: .infinity, maxHeight: 54)
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .background(Color.Siso.Primary.main)
                .clipShape(.rect(cornerRadius: 27))
            }
    }
    
    private func skipButton() -> some View {
        return Button {
            delegate?.dismissProfileSheet()
            delegate?.pushProfile(.introduce)
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18))
                .fontWeight(.semibold)
                .foregroundStyle(Color.Siso.Gray._50)
        }
    }
}

#Preview {
    ImageHelperSheet(delegate: nil, userProfile: .empty) { images in
        
    }
}
