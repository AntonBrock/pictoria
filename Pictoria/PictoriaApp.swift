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

    var body: some Scene {
        WindowGroup {
            switch scenario {
            case .onboarding:
                Onboarding(onClose: {
                    UserDefaults.standard.setValue(true, forKey: "ShownOnboarding")
                    scenario = .mainScreen
                })
            case .mainScreen:
                NavigationView {
                    VStack {
                        switch selectedTab {
                        case .home:
                            MainScreen {
                                withAnimation {
                                    selectedTab = .profile
                                }
                            }
                        case .profile:
                            Text("Profile")
                        }
                    }
                }
                .transition(.opacity)
                .navigationBarTitleDisplayMode(.inline)
                .overlay(
                    TabBar(selectedTab: $selectedTab), alignment: .bottom
                )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            if UserDefaults.standard.bool(forKey: "ShownOnboarding") {
                                scenario = .mainScreen
                            } else {
                                scenario = .onboarding
                            }
                        }
                    }
                }
            }
        }
    }
}
