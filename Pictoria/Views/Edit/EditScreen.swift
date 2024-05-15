//
//  EditScreen.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI

struct EditScreen: View {
    
    var didSaveImage: (() -> Void)
    var didSaveCollage: (() -> Void)
    
    var body: some View {
        VStack {
            HStack {
                NavigationLink {
                    EditScreenOnboarding {
                        didSaveImage()
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image("main_screen-edit_ic")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Edit photo now")
                            .foregroundStyle(Colors.deepGray)
                            .font(.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                NavigationLink {
                    CollageOnboarding {
                        didSaveCollage()
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image("main_screen-collage_ic")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Collage my photos")
                            .foregroundStyle(Colors.deepGray)
                            .font(.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }

            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 50)
            
            Spacer()
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

