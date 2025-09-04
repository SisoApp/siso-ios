//
//  ImageProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 9/3/25.
//

import SwiftUI
import network
import model

struct ImageDisplayItem {
    let id: Int?
    let image: UIImage?
    let url: String?
    let isServerImage: Bool
    
    init(serverImage: ImageDTO) {
        self.id = serverImage.id
        self.image = nil
        self.url = serverImage.presignedUrl
        self.isServerImage = true
    }
    
    init(localImage: UIImage) {
        self.id = nil
        self.image = localImage
        self.url = nil
        self.isServerImage = false
    }
}

extension ImageProfileView {
    final class ImageProfileViewModel: ObservableObject {
        @Published var serverImages: [ImageDTO]?
        
        func imageSources() -> [UIImage] {
            return []
        }
        
        func getServerImages() async {
            let serverImages = try? await ImageNetworkManager.shared.getMyImages()
            
            await MainActor.run {
                self.serverImages = serverImages
            }
        }
        
        func uploadImages(_ images: [UIImage]) async throws {
            try await ImageNetworkManager.shared.uploadImages(images)
        }
        
        func removeServerImage(for id: Int) async throws {
            guard serverImages?.contains(where: { $0.id == id }) == true else { return }
            
            try await ImageNetworkManager.shared.removeImage(for: id)
            
            await MainActor.run {
                serverImages?.removeAll(where: { $0.id == id })
            }
        }
    }
}
