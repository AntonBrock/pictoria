//
//  Projetcs.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 15.05.2024.
//

import SwiftUI

struct Projetcs: View {
    
    @State var images: [UIImage] = []
    
    var body: some View {
        ScrollView(.vertical) {
            if !images.isEmpty {
                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 10),
                              GridItem(.flexible(), spacing: 10),
                              GridItem(.flexible(), spacing: 10)], spacing: 8)
                {
                    ForEach(images, id: \.self) { image in
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 114, height: 114)
                            .cornerRadius(16)
                            .overlay(
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .cornerRadius(16)
                            )
                    }
                }
                .padding(.top, 16)
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
                self.images = imageDataArray.compactMap { UIImage(data: $0) }
            }
        }
    }
}
