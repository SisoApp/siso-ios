//
//  ImageProfileViewModel.swift
//  profile
//
//  Created by 멘태 on 9/3/25.
//

import SwiftUI
import network

extension ImageProfileView {
    final class ImageProfileViewModel {
        func uploadImages(_ images: [UIImage]) async throws {
            try await ImageNetworkManager.shared.uploadImages(images)
        }
    }
}
