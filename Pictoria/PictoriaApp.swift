//
//  PictoriaApp.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI

@main
struct PictoriaApp: App {
    
    enum Scenario {
        case onboarding
        case mainScreen
    }
    
    @State private var scenario: Scenario = .mainScreen
    @State private var selectedTab: Tab = .home
    @State private var isGuideActive = false
    
    @State private var animatedLogo: Bool = false
    @State private var isHiddenTabBar = false

    var body: some Scene {
        WindowGroup {
            switch scenario {
            case .onboarding:
                Onboarding(onClose: {
                    UserDefaults.standard.setValue(true, forKey: "ShownOnboarding")
                    scenario = .mainScreen
                })
                .preferredColorScheme(.light)
            case .mainScreen:
                NavigationView {
                    VStack {
                        switch selectedTab {
                        case .home:
                            MainScreen(showed: $animatedLogo) {
                                withAnimation {
                                    isHiddenTabBar = true
                                }
                            } didSave: {
                                withAnimation {
                                    isHiddenTabBar = false
                                    selectedTab = .profile
                                }
                            }
                        case .profile:
                            Profile() {
                                withAnimation {
                                    isHiddenTabBar = true
                                }
                            }
                        }
                    }
                    .onAppear {
                        withAnimation {
                            isHiddenTabBar = false
                        }
                    }
                }
                .transition(.opacity)
                .navigationBarTitleDisplayMode(.inline)
                .overlay(
                    TabBar(selectedTab: $selectedTab, isHidden: $isHiddenTabBar), alignment: .bottom
                )
                .onAppear {
                    withAnimation {
                        if UserDefaults.standard.bool(forKey: "ShownOnboarding") {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                scenario = .mainScreen
                            }
                        } else {
                            scenario = .onboarding
                        }
                    }
                }
                .preferredColorScheme(.light)
            }
        }
    }
}
