//
//  CollageOnboarding.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 15.05.2024.
//

import SwiftUI

enum CollageType {
    case twoPhoto
    case threePhoto
    case fourPhoto
    case fivePhoto
    case none
}

struct CollageOnboarding: View {
    
    @State var otherParams: UIImage?
    @State var selectedImagesForScreen: [UIImage] = []
    
    @State var goToCollageScreen: Bool = false
    
    @State var selectedImages: [UIImage]? = []
    @State var selectedCollage: CollageType = .none
    @State var presentSelectingImages: Bool = false
    
    var didSaveCollage: (() -> Void)

    var body: some View {
        
        VStack {
            Text("Collage your\nphotos now")
                .foregroundStyle(Colors.blacker)
                .font(.system(size: 26, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
            
            Text("Select your photos and start editing right away")
                .foregroundStyle(Colors.blacker)
                .font(.system(size: 17, weight: .medium))
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 26)
            
            HStack(spacing: 8) {
                Image("collage_fourLines_ic")
                    .resizable()
                    .frame(width: 175, height: 175)
                    .onTapGesture {
                        selectedCollage = .twoPhoto
                    }
                    .overlay {
                        if selectedCollage == .twoPhoto {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Colors.deepBlue, lineWidth: 3)
                        }
                    }
                
                Image("collage_fourLines_ic")
                    .resizable()
                    .frame(width: 175, height: 175)
                    .onTapGesture {
                        selectedCollage = .fourPhoto
                    }
                    .overlay {
                        if selectedCollage == .fourPhoto {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Colors.deepBlue, lineWidth: 3)
                        }
                    }

            }
            .padding(.top, 24)
            
            HStack(spacing: 8) {
                Image("collage_threeLines_ic")
                    .resizable()
                    .frame(width: 175, height: 175)
                    .onTapGesture {
                        selectedCollage = .threePhoto
                    }
                    .overlay {
                        if selectedCollage == .threePhoto {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Colors.deepBlue, lineWidth: 3)
                        }
                    }
                
                Image("collage_fiveLines_ic")
                    .resizable()
                    .frame(width: 175, height: 175)
                    .onTapGesture {
                        selectedCollage = .fivePhoto
                    }
                    .overlay {
                        if selectedCollage == .fivePhoto {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Colors.deepBlue, lineWidth: 3)
                        }
                    }
            }
            .padding(.top, 8)
            
            Button {
                presentSelectingImages.toggle()
            } label: {
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedCollage == .none ? Colors.deepGray : Colors.deepBlue)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .overlay {
                        Text("Open")
                            .foregroundColor(.white)
                    }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .disabled(selectedCollage == .none)
            .padding(.top, 16)
            
            NavigationLink(destination: Collage(
                selectedCollageType: $selectedCollage,
                selectedImages: $selectedImagesForScreen,
                didSave: {
                    didSaveCollage()
                }
            ), isActive: $goToCollageScreen) {
                EmptyView()
            }
            
            Spacer()
        }
        .navigationTitle("Collage")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $presentSelectingImages) {
            PhotoPicker(selectedImages: $selectedImages,
                        selectedImage: $otherParams,
                        countForSelected: selectedCollage == .twoPhoto
                        ? 2 : selectedCollage == .threePhoto
                        ? 3 : selectedCollage == .fourPhoto
                        ? 4 : 5) {
                
                selectedImagesForScreen = selectedImages ?? []                
                goToCollageScreen.toggle()
            }
        }
    }
}
