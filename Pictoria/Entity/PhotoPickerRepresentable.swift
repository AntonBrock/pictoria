//
//  PhotoPickerRepresentable.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 14.05.2024.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var selectedImages: [UIImage]?
    @Binding var selectedImage: UIImage?
    
    var countForSelected: Int
    
    var dismiss: (() -> Void)
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = countForSelected
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            
            guard let provider = results.first?.itemProvider else {
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var images: [UIImage] = []
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image as? UIImage
                        self?.parent.dismiss()
                        
                    }
                }
            }
            
            for result in results {
                dispatchGroup.enter()
                
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                images.append(image)
                            }
                            dispatchGroup.leave()
                        }
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.parent.selectedImages = images
                self.parent.dismiss()
            }
        }
    }
}
