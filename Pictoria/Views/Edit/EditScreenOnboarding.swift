//
//  EditScreenOnboarding.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI
import Photos

struct EditScreenOnboarding: View {
    
    @State var isEditPhotoScreenPresented: Bool = false
    @State var statusPHPhotoLibrary: PHAuthorizationStatus = .denied

    @State private var otherParams: [UIImage]?
    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    
    @State private var showDeniedAccess: Bool = false
    
    var didSaveImage: (() -> Void)

    var body: some View {
        VStack {
            Image("main_screen_editPhoto_ic")
                .resizable()
                .padding(.top, 20)
                .frame(maxHeight: 300)
            
            Text("Edit your photo now")
                .font(.system(size: 24,weight: .bold))
                .foregroundStyle(Colors.blacker)
                .padding(.top, 24)
            
            Text("Select a photo and start editing immediately")
                .foregroundStyle(Colors.blacker)
                .font(.system(size: 17))
                .padding(.top, 5)
            
            Button {
                if statusPHPhotoLibrary == .authorized {
                    isShowingPicker = true
                } else {
                    PHPhotoLibrary.requestAuthorization { status in
                        DispatchQueue.main.async {
                            statusPHPhotoLibrary = status
                            
                            if status == .authorized {
                                isShowingPicker = true
                            } else {
                                showDeniedAccess = true
                            }
                        }
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Colors.deepBlue)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .overlay {
                        Text("Open")
                            .foregroundColor(.white)
                    }
            }
            .padding()
            .sheet(isPresented: $isShowingPicker) {
                PhotoPicker(selectedImages: $otherParams, selectedImage: $selectedImage, countForSelected: 1) {
                    isEditPhotoScreenPresented.toggle()
                }
            }
            
            NavigationLink(destination: EditPhotoScreen(selectedImage: $selectedImage, didSave: {
                didSaveImage()
            }), isActive: $isEditPhotoScreenPresented) {
                EmptyView()
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            PHPhotoLibrary.requestAuthorization { status in
                statusPHPhotoLibrary = status
            }
        }
        .alert(isPresented: $showDeniedAccess) {
            Alert(
                title: Text("The Pictoria application requests permission to access the photo from the gallery."), 
                message: Text("Go to the application settings and get access to the desired functions"),
                dismissButton: .default(
                    Text("Go to settings")
                        .font(.system(size: 17, weight: .bold)), action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    })
                )
            }
    }
}
