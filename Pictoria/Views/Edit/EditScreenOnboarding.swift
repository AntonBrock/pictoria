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
            
            if statusPHPhotoLibrary == .authorized {
                NavigationLink(destination: EditPhotoScreen(), isActive: $isEditPhotoScreenPresented) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.deepBlue)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .overlay {
                                Text("Open")
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
            } else {
                NavigationLink(destination: EditPhotoScreen(), isActive: $isEditPhotoScreenPresented) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.deepBlue)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .overlay {
                                Text("Open")
                                    .foregroundColor(.white)
                            }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .onTapGesture {
                        PHPhotoLibrary.requestAuthorization { status in
                            statusPHPhotoLibrary = status
                            
                            switch status {
                            case .authorized:
                                self.isEditPhotoScreenPresented = true
                            case .denied, .restricted:
                                print("Доступ к фотографиям запрещен или ограничен")
                            case .notDetermined:
                                print("Пользователь еще не принял решение о доступе к фотографиям")
                            @unknown default:
                                fatalError("Непредвиденное состояние разрешения на доступ к фотографиям")
                            }
                        }
                    }
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
