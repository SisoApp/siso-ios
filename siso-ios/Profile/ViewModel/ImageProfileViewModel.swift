//
//  ImageProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 9/3/25.
//

import SwiftUI
import network
import model

extension ImageProfileView {
    final class ImageProfileViewModel {
        var serverImages: [ImageDTO]?
        
        func imageSources() -> [UIImage] {
            return []
        }
        
        func getServerImages() async {
            serverImages = try? await ImageNetworkManager.shared.getMyImages()
        }
        
        func uploadImages(_ images: [UIImage]) async throws {
            try await ImageNetworkManager.shared.uploadImages(images)
        }
        
        func removeServerImage(for id: Int) async throws {
            guard serverImages?.contains(where: { $0.id == id }) == true else { return }
            
            try await ImageNetworkManager.shared.removeImage(for: id)
            serverImages?.removeAll(where: { $0.id == id })
        }
    }
}
