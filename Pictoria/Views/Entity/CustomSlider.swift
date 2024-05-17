//
//  CustomSlider.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 17.05.2024.
//

import SwiftUI

//struct CustomSlider: View {
//    
//    @Binding var value: Double
//
//    var body: some View {
//        VStack {
//            ZStack {
//                // Background track
//                RoundedRectangle(cornerRadius: 16)
//                    .foregroundColor(Colors.middleGray)
//                    .frame(height: 16)
//                
//                // Filled track
//                GeometryReader { geometry in
//                    ZStack(alignment: .leading) {
//                        RoundedRectangle(cornerRadius: 16)
//                            .foregroundColor(Colors.deepBlue)
//                            .frame(width: CGFloat(value) * geometry.size.width, height: 16)
//                            .animation(.linear, value: value)
//                        
//                        // Slider circle
//                        Circle()
//                            .foregroundColor(.white)
//                            .frame(width: 12, height: 12)
//                            .offset(x: CGFloat(value) * geometry.size.width - 15, y: 0)
//                            .gesture(
//                                DragGesture()
//                                    .onChanged { gesture in
//                                        let newValue = gesture.location.x / geometry.size.width
//                                        self.value = min(max(0, newValue), 1) * 100
//                                    }
//                            )
//                            .animation(.linear, value: value)
//                    }
//                }
//                .frame(height: 12)
//            }
//        }
//    }
//}

struct CustomSlider: View {
    @Binding var value: Int // Изменение типа данных на Int

    var body: some View {
        VStack {
            ZStack {
                // Background track
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Colors.middleGray)
                    .frame(height: 16)
                
                // Filled track
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Colors.deepBlue)
                            .frame(width: CGFloat(value + 5) / 100 * geometry.size.width, height: 16) // Изменение логики расчета ширины
                            .animation(.linear, value: value)
                        
                        // Slider circle
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 12, height: 12)
                            .offset(x: CGFloat(value + 5) / 100 * geometry.size.width - 15, y: 0) // Изменение логики расположения
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newValue = Int(gesture.location.x / geometry.size.width * 100) // Изменение логики обработки значения
                                        self.value = min(max(5, newValue), 100)
                                    }
                            )
                            .animation(.linear, value: value)
                    }
                }
                .frame(height: 12)
            }
        }
    }
}
