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
    @State private var isHiddenTabBar = true
    
    @State private var wasShowingTab: Bool = false

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
                            } showTabBar: {
                                withAnimation {
                                    wasShowingTab = true
                                    isHiddenTabBar = false
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
                            if wasShowingTab || !UserDefaults.standard.bool(forKey: "ShownOnboarding")  {
                                isHiddenTabBar = false
                                wasShowingTab = true
                            }
                        }
                    }
                }
                .transition(.opacity)
                .navigationBarTitleDisplayMode(.inline)
                .overlay(
                    TabBar(selectedTab: $selectedTab, isHidden: $isHiddenTabBar), alignment: .bottom
                )
                .preferredColorScheme(.light)
            }
        }
    }
}
