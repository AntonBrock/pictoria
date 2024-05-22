//
//  Projetcs.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 15.05.2024.
//

import SwiftUI

struct Projetcs: View {
    
    @State var images: [UIImage] = []
    @State var isLoading: Bool = true
    
    var body: some View {
        ScrollView(.vertical) {
            if !images.isEmpty && !isLoading {
                LazyVGrid(
                    columns: [GridItem(.fixed(114), spacing: 10),
                              GridItem(.fixed(114), spacing: 10),
                              GridItem(.fixed(114), spacing: 10)], spacing: 8)
                {
                    ForEach(images, id: \.self) { image in
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                            .frame(width: 114, height: 114)
                            .overlay(
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 114, height: 114)
                                    .scaledToFill()
                                    .clipped()
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                            )
                        
                    }
                }
                .padding(.top, 16)
            } else if isLoading {
                VStack {
                    
                    ProgressView()
                        .foregroundStyle(Colors.deepBlue)
                        .padding(.bottom, 10)
                        .padding(.top, 35)
                    
                    Text("We need a few seconds for loading your projects")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 20, weight: .medium))
                        .padding(.horizontal, 16)
                        .foregroundColor(Colors.deepGray)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                VStack {
                    Text("This is where your projects will be. Start editing...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.system(size: 34, weight: .bold))
                        .padding(.horizontal, 16)
                        .foregroundColor(Colors.blacker)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Image("profile_projects_empty_ic")
                        .resizable()
                        .frame(maxWidth: 270, maxHeight: 258)
                        .scaledToFill()
                        .padding(.top, 26)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.top, 32)
            }
        }
        .presentationDragIndicator(.hidden)
        .padding(.horizontal, 16)
        .navigationTitle("My projects")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if let imageDataArray = UserDefaults.standard.array(forKey: "ImagesProjects") as? [Data] {
                DispatchQueue.global().async {
                    
                    let uiImages = imageDataArray.compactMap { UIImage(data: $0) }
                    DispatchQueue.main.async {
                        self.images = uiImages
                        self.isLoading = false
                    }
                }
            } else {
                self.isLoading = false
            }
        }
    }
}
