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
    
    @State private var isRotating: Bool = false
    @State private var angle: Double = 0
    
    @State private var showOnboarding: Bool = false

    @Binding var showed: Bool
    
    var hideTabBar: (() -> Void)
    var showTabBar: (() -> Void)
    var didSave: (() -> Void)
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    Image("app_launch_ic")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .offset(y: yOffset)
                    
                    Image("dinamic_cyrcle_ic")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(angle))
                        .offset(y: yOffset - 12)
                }
            }
            
            HStack {
                NavigationLink(destination: EditScreen(hideTabBar: {
                    hideTabBar()
                }, didSaveImage: {
                    didSave()
                }, didSaveCollage: {
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
                if showed {
                    opacity = 1
                }
            }
            .padding(.top, 50)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            if !showed {
                if !UserDefaults.standard.bool(forKey: "ShownOnboarding") {
                    showOnboarding = true
                } else {
                    yOffset = 80
                    startRotating()
                    
                    #warning("WARNING: Здесь задать когда скрыть сплеш скрин и показать контент или после определенный действий")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                        stopRotatingAndShowContent()
                    }
                }
            } else {
                yOffset = 80
                yOffset -= 150
            }
        }
        .fullScreenCover(isPresented: $showOnboarding) {
            Onboarding(onClose: {
                UserDefaults.standard.setValue(true, forKey: "ShownOnboarding")
                withAnimation {
                    showOnboarding = false
                    yOffset = 80
                    yOffset -= 150
                    opacity = 1
                    angle = 0
                    showed = true
                }
            })
            .preferredColorScheme(.light)
        }
    }
    
    // MARK: - Animation Start / End
    private func startRotating() {
        withAnimation(Animation.linear(duration: 0.9)) {
            angle += 360
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            if !showed {
                self.startRotating()
            }
        }
    }
    
    private func stopRotatingAndShowContent() {
        let currentAngle = angle.truncatingRemainder(dividingBy: 360)
        let remainingAngle = 360 - currentAngle
        let durationAnimation = (remainingAngle / 360) * 0.9
        
        withAnimation(Animation.linear(duration: durationAnimation)) {
            angle += remainingAngle
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + durationAnimation) {
            angle = 0
            
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                yOffset -= 150
                
                showed = true
                showTabBar()
                
                withAnimation(Animation.easeInOut(duration: 0.2)) {
                    opacity = 1
                }
            }
        }
    }
}
