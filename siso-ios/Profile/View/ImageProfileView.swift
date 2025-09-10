//
//  ImageProfileView.swift
//  siso-ios
//
//  Created by 멘태 on 8/12/25.
//

import SwiftUI
import designSystem
import network
import model

public struct ImageProfileView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject private var userProfile: UserProfile
    @StateObject private var viewModel: ImageProfileViewModel = .init()
    @Binding var currentPage: SignUpProfilePage
    @State private var displayImages: [ImageDisplayItem] = []
    @State private var showAlert: Bool = false
    
    private var images: [UIImage] = [] // 이미지 등록을 건너뛸 때 초기 값으로 복구하기 위한 초기값 저장 변수
    
    weak var delegate: ProfileCoordinatorDelegate?
    
    private let mode: ProfileMode
    private let limit: Int = 5
    
    private var imageSlots: [ImageDisplayItem?] {
        var slots: [ImageDisplayItem?] = Array(repeating: nil, count: limit)
        for (index, item) in displayImages.enumerated() {
            if index < limit {
                slots[index] = item
            }
        }
        return slots
    }
    
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
        .alert("오류", isPresented: $showAlert) {
            Button("확인") { }
        } message: {
            Text("작업이 실패했습니다. 다시 시도해주세요.")
        }
        .task {
            if mode == .edit {
                await viewModel.getServerImages()
                loadAndMergeImages()
            }
        }
        .onChange(of: viewModel.serverImages) { oldValue, newValue in
            if oldValue != newValue { loadAndMergeImages() }
        }
        .onChange(of: userProfile.profileImages) { oldValue, newValue in
            if oldValue != newValue { loadAndMergeImages() }
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
        return ZStack(alignment: .topTrailing) {
            Group {
                if let item = imageSlots[0] {
                    if let urlString = item.url,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 206)
                                    .background(Color.Siso.Gray._20)
                                    .clipShape(.rect(cornerRadius: 12))
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 206)
                                    .background(Color.Siso.Gray._20)
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 12))
                            case .failure:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else if let localImage = item.image {
                        Image(uiImage: localImage)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 206)
                            .background(Color.Siso.Gray._20)
                            .clipped()
                            .clipShape(.rect(cornerRadius: 12))
                    }
                    
                    Button {
                        removeImage(at: 0)
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
        }
        .padding(.top, 44)
    }
    
    private func subImageView() -> some View {
        let size =  (UIScreen.main.bounds.width - (8 * 3 + 16 * 2)) / 4
        
        return HStack(spacing: 8) {
            ForEach(1...4, id: \.self) { index in
                let imageItem = imageSlots[index]
                
                ZStack(alignment: .topTrailing) {
                    Group {
                        if let item = imageItem {
                            if let urlString = item.url,
                               let url = URL(string: urlString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: size, height: size)
                                            .background(Color.Siso.Gray._20)
                                            .clipShape(.rect(cornerRadius: 12))
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: size, height: size)
                                            .background(Color.Siso.Gray._20)
                                            .clipped()
                                            .clipShape(.rect(cornerRadius: 12))
                                    case .failure:
                                        EmptyView()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else if let localImage = item.image {
                                Image(uiImage: localImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: size, height: size)
                                    .background(Color.Siso.Gray._20)
                                    .clipped()
                                    .clipShape(.rect(cornerRadius: 12))
                            }
                            
                            Button {
                                removeImage(at: index)
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
                                .frame(width: size, height: size)
                                .frame(maxWidth: .infinity)
                                .background(Color.Siso.Gray._20)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
            }
        }
        .padding(.top, 8)
    }
    
    private func addButton() -> some View {
        let isActive: Bool = displayImages.count < limit
        
        return PrimaryButton(title: "사진 추가하기 (\(displayImages.count)/\(limit))", isActive: isActive) {
            delegate?.presentProfile(sheet: .imageHelper(mode, { images in
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
            switch mode {
            case .signUp:
                currentPage = .introduce
            case .edit:
                Task {
                    do {
                        try await viewModel.uploadImages(userProfile.profileImages)
                        userProfile.profileImages.removeAll()
                        delegate?.pop()
                    } catch {
                        showAlert = true
                    }
                }
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
    
    // 서버 이미지(URL)와 로컬 이미지(UIImage)를 병합하는 함수
    private func loadAndMergeImages() {
        var mergedImages: [ImageDisplayItem] = []
        
        if let serverImages = viewModel.serverImages {
            for serverImage in serverImages {
                mergedImages.append(ImageDisplayItem(serverImage: serverImage))
            }
        }
        
        let remainingSlots = limit - mergedImages.count
        for (index, localImage) in userProfile.profileImages.enumerated() {
            if index < remainingSlots {
                mergedImages.append(ImageDisplayItem(localImage: localImage))
            }
        }
        
        displayImages = mergedImages
    }
    
    private func removeImage(at index: Int) {
        guard index < displayImages.count else { return }
        let item = displayImages[index]
        
        if item.isServerImage { // 서버이미지 삭제
            if let id = item.id {
                Task {
                    do {
                        try await viewModel.removeServerImage(for: id)
                        
                    } catch {
                        showAlert = true
                    }
                }
            }
        } else { // 로컬이미지 삭제
            let serverImageCount = viewModel.serverImages?.count ?? 0
            let localIndex = index - serverImageCount
            if localIndex >= 0 && localIndex < userProfile.profileImages.count {
                userProfile.profileImages.remove(at: localIndex)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ImageProfileView(delegate: nil, currentPage: .constant(.image) , userProfile: .empty, mode: .signUp)
    }
}
