//
//  Colors.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI

class Colors {
    static let gray: Color = Color(hex: "#D6D6D6")
    static let deepBlue: Color = Color(hex: "#415DFF")
    static let lightGray: Color = Color(hex: "#E5E5EA")
    static let middleGray: Color = Color(hex: "#F6F6F6")
    static let deepGray: Color = Color(hex: "#8C9AAC")
    static let blacker: Color = Color(hex: "#1E2832")
}

// MARK: - Extenstion
extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
