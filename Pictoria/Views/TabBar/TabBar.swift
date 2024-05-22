//
//  TabBar.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home
    case profile
}

struct TabBar: View {
    
    @Binding var selectedTab: Tab
    @Binding var isHidden: Bool
    
    let screenWidth = UIScreen.main.bounds.size.width
    var tabs: [Tab] = [.home, .profile]
    
    var iconNameForTab: [Tab: String] = [
        .home: "tb_home_unselected_ic",
        .profile: "tb_profile_unselected_ic"
    ]
    
    var titleTab: [Tab: String] = [
        .home: "Home",
        .profile: "Profile"
    ]
    
    var selectedIconNameForTab: [Tab: String] = [
        .home: "tb_home_selected_ic",
        .profile: "tb_profile_selected_ic"
    ]
    
    var body: some View {
        if !isHidden {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    ForEach(tabs, id: \.self) { tab in
                        VStack {
                            Image(tab == selectedTab ? selectedIconNameForTab[tab]! : iconNameForTab[tab]!)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        selectedTab = tab
                                    }
                                }
                            
                            Text(titleTab[tab]!)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(tab == selectedTab ? Colors.deepBlue : Colors.gray)
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.bottom, screenWidth < 375 ? 15 : 45)
                .padding(.top, -10)
            }
            .background(.white)
            .frame(maxWidth: .infinity, maxHeight: 30)
        }
    }
}
