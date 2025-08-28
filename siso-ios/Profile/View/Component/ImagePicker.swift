//
//  ImagePicker.swift
//  profile
//
//  Created by 멘태 on 8/15/25.
//

import SwiftUI
import UIKit

public struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var userProfile: UserProfile
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    public init(userProfile: UserProfile) {
        self.userProfile = userProfile
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        public func imagePickerController(_ picker: UIImagePickerController,
                                            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                if let compressedData = image.jpegData(compressionQuality: 0.3),
                   let compressedImage: UIImage = UIImage(data: compressedData) {
                    parent.userProfile.profileImages.append(compressedImage)
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
