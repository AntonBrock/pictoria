//
//  Collage.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 15.05.2024.
//

import SwiftUI
import PhotosUI

struct Collage: View {
    
    @Binding var selectedCollageType: CollageType
    @Binding var selectedImages: [UIImage]

    var didSave: (() -> Void)
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack {
                Text("Your collage")
                    .foregroundStyle(Colors.blacker)
                    .font(.system(size: 26, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                
                Text("Click refresh to shuffle the images in the collage")
                    .foregroundStyle(Colors.blacker)
                    .font(.system(size: 17, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 26)
                
                if !selectedImages.isEmpty {
                    if selectedCollageType == .twoPhoto {
                        twoCollageLayout()
                    }
                    
                    if selectedCollageType == .threePhoto {
                        threeCollageLayout()
                    }
                    
                    if selectedCollageType == .fourPhoto {
                        fourCollageLayout()
                    }
                    
                    if selectedCollageType == .fivePhoto {
                        fiveCollageLayout()
                    }
                }
                
                Button {
                    selectedImages.shuffle()
                } label: {
                    Image("collage_refresh_ic")
                        .resizable()
                        .frame(width: 44, height: 44)
                        .padding(.top, 16)
                }
                
                Button {
                    switch selectedCollageType {
                    case .twoPhoto:
                        let renderer = ImageRenderer(content: twoCollageLayout())
                        
                        if let uiImage = renderer.uiImage {
                            saveToCashImage(uiImage: uiImage)
                        }
                    case .threePhoto:
                        let renderer = ImageRenderer(content: threeCollageLayout())
                        
                        if let uiImage = renderer.uiImage {
                            saveToCashImage(uiImage: uiImage)
                        }
                    case .fourPhoto:
                        let renderer = ImageRenderer(content: fourCollageLayout())
                        if let uiImage = renderer.uiImage {
                            saveToCashImage(uiImage: uiImage)
                        }
                    case .fivePhoto:
                        let renderer = ImageRenderer(content: fiveCollageLayout())
                        if let uiImage = renderer.uiImage {
                            saveToCashImage(uiImage: uiImage)
                        }
                    case .none:
                        return
                    }
                    
                    didSave()
                    
                } label: {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Colors.deepBlue)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .overlay {
                            Text("Save")
                                .foregroundColor(.white)
                        }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .padding(.horizontal, 16)
            }
            .navigationTitle("Collage")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.top, 32)
            .padding(.horizontal, 16)
            .onTapGesture {
                selectedImages.shuffle()
            }
        }
        .scrollIndicators(.hidden)
        
        Spacer()
    }
    
    private func saveToCashImage(uiImage: UIImage) {
        var images: [UIImage] = []

        if let userDefaultsImages = UserDefaults.standard.array(forKey: "ImagesProjects") as? [Data] {
            for imageData in userDefaultsImages {
                if let image = UIImage(data: imageData) {
                    images.append(image)
                }
            }
        }
        
        images.append(uiImage)
        
        let imageDataArray = images.compactMap { $0.pngData() }
        UserDefaults.standard.set(imageDataArray, forKey: "ImagesProjects")
        
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
    }
    
    // MARK: - Collage for Two Photo
    @ViewBuilder
    private func twoCollageLayout() -> some View {
        Rectangle()
            .fill(.white)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay {
                HStack(spacing: 3) {
                    ForEach(selectedImages.indices, id: \.self) { index in
                        Rectangle()
                            .fill(Color.white)
                            .overlay {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                    }
                }
            }
            .frame(width: 350, height: 350)
            .aspectRatio(contentMode: .fit)
    }
    
    // MARK: - Collage for Three Photo
    @ViewBuilder
    private func threeCollageLayout() -> some View {
        Rectangle()
            .fill(.white)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay {
                HStack(spacing: 3) {
                    ForEach(selectedImages.indices, id: \.self) { index in
                        Rectangle()
                            .fill(Color.white)
                            .overlay {
                                Image(uiImage: selectedImages[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                    }
                }
            }
            .frame(width: 350, height: 350)
            .aspectRatio(contentMode: .fit)
    }
    
    // MARK: - Collage for Four Photo
    @ViewBuilder
    private func fourCollageLayout() -> some View {
        Rectangle()
            .fill(.white)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay {
                VStack(spacing: 3) {
                    HStack(spacing: 3) {
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[0])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                        
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[1])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                    }
                    
                    HStack(spacing: 3) {
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[2])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                        
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[3])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                    }
                }
            }
            .frame(width: 350, height: 350)
            .aspectRatio(contentMode: .fit)
    }
    
    // MARK: - Collage for Five Photo
    @ViewBuilder
    private func fiveCollageLayout() -> some View {
        Rectangle()
            .fill(.white)
            .aspectRatio(1.0, contentMode: .fit)
            .overlay {
                VStack(spacing: 3) {
                    HStack(spacing: 3) {
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[0])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                            .frame(width: 250, height: 150)
                        
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[1])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                            .frame(width: 80, height: 150)
                    }
                    
                    HStack(spacing: 3) {
                        VStack(spacing: 3) {
                            Rectangle()
                                .fill(.white)
                                .overlay {
                                    Image(uiImage: selectedImages[2])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .clipped()
                                .frame(width: 130, height: 100)
                            
                            Rectangle()
                                .fill(.white)
                                .overlay {
                                    Image(uiImage: selectedImages[3])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                .clipped()
                                .frame(width: 130, height: 100)
                        }
                       
                        Rectangle()
                            .fill(.white)
                            .overlay {
                                Image(uiImage: selectedImages[4])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .clipped()
                            .frame(width: 200, height: 200)
                    }
                }
            }
            .frame(width: 350, height: 350)
            .aspectRatio(contentMode: .fit)
    }
}
