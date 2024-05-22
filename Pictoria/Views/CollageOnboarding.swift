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
    
    @State var showLoading: Bool = false
    @State var buttonText: String = "Open"
    var didSaveCollage: (() -> Void)

    var body: some View {
        
        ZStack {
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
                    Image("collage_twoLines_ic")
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
                
                Spacer()
                
                Button {
                    presentSelectingImages.toggle()
                } label: {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(selectedCollage == .none ? Colors.deepGray : Colors.deepBlue)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .overlay {
                            Text(buttonText)
                                .foregroundColor(.white)
                        }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .disabled(selectedCollage == .none)
                .padding(.top, 16)
                .padding(.bottom)
                
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
                            ? 4 : 5
                ) {
                    
                    if selectedCollage == .twoPhoto && selectedImages?.count == 2 {
                        withAnimation {
                            showLoading = true
                        }
                        
                        DispatchQueue.global().async {
                            selectedImagesForScreen = selectedImages ?? []
                        }
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                            goToCollageScreen.toggle()
                        }
                    }
                    
                    if selectedCollage == .threePhoto && selectedImages?.count == 3  {
                        withAnimation {
                            showLoading = true
                        }
                        
                        DispatchQueue.global().async {
                            selectedImagesForScreen = selectedImages ?? []
                        }
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                            goToCollageScreen.toggle()
                        }
                    }
                    
                    if selectedCollage == .fourPhoto && selectedImages?.count == 4  {
                        withAnimation {
                            showLoading = true
                        }
                        
                        DispatchQueue.global().async {
                            selectedImagesForScreen = selectedImages ?? []
                        }
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                            goToCollageScreen.toggle()
                        }
                    }
                    
                    if selectedCollage == .fivePhoto && selectedImages?.count == 5  {
                        withAnimation {
                            showLoading = true
                        }
                        
                        DispatchQueue.global().async {
                            selectedImagesForScreen = selectedImages ?? []
                        }
                        
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
                            goToCollageScreen.toggle()
                        }
                    }
                    
                    buttonText = "Select more"
                }
            }
            .onAppear {
                buttonText = "Open"
                selectedImages = []
                selectedCollage = .none
                presentSelectingImages = false
                goToCollageScreen = false
                showLoading = false
            }
            
            if showLoading {
                VStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.white.opacity(0.5))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
