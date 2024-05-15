//
//  Profile.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 15.05.2024.
//

import SwiftUI

struct Profile: View {
    
    @State var isEditingNameMode: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State var name: String = "Your name"
    
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    @State private var isNeedToOpenProjects: Bool = false
    @State private var isNeedToOpenFeedbackScreen: Bool = false
    @State private var isNeedToOpenTermsScreen: Bool = false
    @State private var isNeedToOpenPrivacy: Bool = false
    
    var body: some View {
        
        ScrollView(.vertical) {
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 86, height: 86)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 0)
                        )
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                } else {
                    Image("profile_default_ic")
                        .resizable()
                        .frame(width: 86, height: 86)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color.white, lineWidth: 0)
                        )
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                }
                
                HStack {
                    if isEditingNameMode {
                        TextField("Your name", text: $name, onEditingChanged: { editing in
                            isEditingNameMode = editing
                        }, onCommit: {
                            isEditingNameMode = false
                            isTextFieldFocused = false
                            UserDefaults.standard.setValue(name, forKey: "UserName")
                        })
                            .frame(maxWidth: 300, alignment: .center)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Colors.blacker)
                            .focused($isTextFieldFocused)
                    } else {
                        Text(name)
                            .foregroundStyle(Colors.blacker)
                            .font(.system(size: 24, weight: .bold))
                    }
                    Button {
                        isEditingNameMode.toggle()
                        isTextFieldFocused.toggle()
                    } label: {
                        Image(isEditingNameMode ? "profile_save_ic" : "profile_edit_ic")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                
                VStack {
                    NavigationLink(destination: Projetcs(), isActive: $isNeedToOpenProjects) {
                        RoundedRectangle(cornerRadius: 14)
                             .fill(Colors.middleGray)
                             .frame(height: 50)
                             .overlay(alignment: .leading) {
                                 HStack(spacing: 10) {
                                     Image("profile_projects_ic")
                                         .resizable()
                                         .frame(width: 24, height: 24)
                                     
                                     Text("My projects")
                                         .foregroundStyle(Colors.deepBlue)
                                         .font(.system(size: 17, weight: .bold))
                                 }
                                 .padding(.leading, 12)
                                 .padding(.vertical, 13)
                             }
                             .onTapGesture {
                                 isNeedToOpenProjects.toggle()
                             }
                    }
                    
                    NavigationLink(destination: EmptyView(), isActive: $isNeedToOpenFeedbackScreen) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.middleGray)
                            .frame(height: 50)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("profile_feedback_ic")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("Fedback submissions")
                                        .foregroundStyle(Colors.deepBlue)
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .padding(.leading, 12)
                                .padding(.vertical, 13)
                            }
                    }
                    
                    NavigationLink(destination: EmptyView(), isActive: $isNeedToOpenTermsScreen) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.middleGray)
                            .frame(height: 50)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("profile_doc_ic")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("Terms and conditions")
                                        .foregroundStyle(Colors.deepBlue)
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .padding(.leading, 12)
                                .padding(.vertical, 13)
                            }
                    }
                    
                    NavigationLink(destination: EmptyView(), isActive: $isNeedToOpenPrivacy) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Colors.middleGray)
                            .frame(height: 50)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("profile_policy_ic")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    
                                    Text("Privacy policy")
                                        .foregroundStyle(Colors.deepBlue)
                                        .font(.system(size: 17, weight: .bold))
                                }
                                .padding(.leading, 12)
                                .padding(.vertical, 13)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 29)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 32)
        }
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(selectedImage: $selectedImage) {
                self.selectedImage = selectedImage
                
                saveImageToUserDefaults()
            }
        }
        .onAppear {
            if let name = UserDefaults.standard.string(forKey: "UserName") {
                self.name = name
            }
            
            loadImageFromUserDefaults()
        }
    }
    
    private func saveImageToUserDefaults() {
        guard let selectedImage = selectedImage else { return }
        if let imageData = selectedImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "selectedImage")
        }
    }
    
    private func loadImageFromUserDefaults() {
        if let imageData = UserDefaults.standard.data(forKey: "selectedImage"),
           let image = UIImage(data: imageData) {
            selectedImage = image
        }
    }

}
