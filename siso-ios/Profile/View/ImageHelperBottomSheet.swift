//
//  ImageHelperBottomSheet.swift
//  profile
//
//  Created by 멘태 on 8/14/25.
//

import SwiftUI

public struct ImageHelperBottomSheet: View {
    public var delegate: ProfileCoordinatorDelegate?
    
    public init(delegate: ProfileCoordinatorDelegate?) {
        self.delegate = delegate
    }
    
    public var body: some View {
        VStack(spacing: 32) {
            HStack {
                Text("사진 업로드 도움말")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                
                Spacer()
                
                Image(systemName: "xmark")
                    .frame(width: 24, height: 24)
                    .bold()
            }
            
            Text("꼭 얼굴이 아니더라도 내가 관심있는 분야의\n사진을 올려줘도 좋아요\n예시) 반려동물, 꽃, 운동하는 사진, 등산 등")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 18))
                .foregroundStyle(Color.Siso.Gray._60)
            
            HStack {
                imageExample(name: "dog")
                imageExample(name: "flower")
                imageExample(name: "baseball")
            }
            
            VStack(spacing: 8) {
                cameraButton()
                galleryButton()
            }
        }
        .padding()
    }
    
    private func imageExample(name: String) -> some View {
        return Image(name)
            .resizable()
            .scaledToFit()
    }
    
    private func cameraButton() -> some View {
        return Button {
            
        } label: {
            Text("카메라로 사진찍기")
                .frame(maxWidth: .infinity, maxHeight: 54)
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
        }
    }
    
    private func galleryButton() -> some View {
        return Button {
            
        } label: {
            Text("앨범에서 가져오기")
                .frame(maxWidth: .infinity, maxHeight: 54)
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
        }
    }
}

#Preview {
    ImageHelperBottomSheet(delegate: nil)
}
