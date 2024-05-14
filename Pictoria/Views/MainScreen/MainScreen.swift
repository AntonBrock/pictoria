//
//  MainScreen.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var yOffset: CGFloat = 80
    @State private var opacity: Double = 0
    @State private var showed: Bool = false
    
    var didSave: (() -> Void)
    
    var body: some View {
        VStack {
            VStack {
                Image("app_launch_ic")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .offset(y: yOffset)
            }
            
            HStack {
                NavigationLink(destination: EditScreen(didSaveImage: {
                    didSave()
                })) {
                    VStack(spacing: 5) {
                        Image("main_screen-edit_ic")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Edit")
                            .foregroundStyle(Colors.deepGray)
                            .font(.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                
                NavigationLink(destination: Onboarding(onClose: {
                    print("Closed Onboarding")
                })) {
                    VStack(spacing: 5) {
                        Image("main_screen-guide_ic")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Guide")
                            .foregroundStyle(Colors.deepGray)
                            .font(.system(size: 17))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .opacity(opacity)
            .animation(.easeIn)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(Animation.easeInOut(duration: 0.2)) {
                        opacity = 1
                    }
                }
            }
            .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !showed {
                    withAnimation(Animation.easeInOut(duration: 0.5)) {
                        yOffset -= 150
                        showed = true
                    }
                }
            }
        }
    }
}
