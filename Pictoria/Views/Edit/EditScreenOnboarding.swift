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

    @State private var isShowingPicker = false
    @State private var selectedImage: UIImage?
    
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
                                print("Access denied or restricted")
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
                PhotoPicker(selectedImage: $selectedImage) {
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
    }
}
