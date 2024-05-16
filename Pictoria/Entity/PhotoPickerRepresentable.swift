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
            
            guard let firstResult = results.first else {
                return
            }
            
            let dispatchGroup = DispatchGroup()
            var selectedImage: UIImage?
            var selectedImages: [UIImage] = []
            
            for result in results {
                dispatchGroup.enter()
                
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        DispatchQueue.main.async {
                            if let image = image as? UIImage {
                                selectedImages.append(image)
                            }
                            dispatchGroup.leave()
                        }
                    }
                } else {
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                if selectedImages.isEmpty {
                    // Если не выбрано ни одной фотографии
                    if let image = firstResult.itemProvider as? UIImage {
                        self.parent.selectedImage = image
                    }
                } else if selectedImages.count == 1 {
                    // Если выбрана только одна фотография
                    self.parent.selectedImage = selectedImages.first
                } else {
                    // Если выбрано несколько фотографий
                    self.parent.selectedImages = selectedImages
                }
                
                self.parent.dismiss()
            }
        }
    }
}
