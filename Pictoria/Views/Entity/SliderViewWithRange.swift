//
//  SliderViewWithRange.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 17.05.2024.
//

import SwiftUI

struct SliderViewWithRange: View {
    
    let currentValue: Binding<Double>
    let sliderBounds: ClosedRange<Int>
    
    @State var sliderViewX: CGFloat = 0
    
    public init(value: Binding<Double>, bounds: ClosedRange<Int>) {
        self.currentValue = value
        self.sliderBounds = bounds
    }
    
    var body: some View {
        GeometryReader { geomentry in
            sliderView(sliderSize: geomentry.size)
        }
    }
    
    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        let sliderViewXCenter = sliderSize.width / 2
                
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Colors.middleGray)
                .frame(height: 16)
            
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)
                                
                // Calculate relative value and thumb location
                let relativeValue = (Float(currentValue.wrappedValue) - Float(sliderBounds.lowerBound)) / Float(sliderBounds.upperBound - sliderBounds.lowerBound)
                let thumbLocation = CGFloat(relativeValue) * sliderSize.width
                
                // Path between starting point to thumb
                lineBetweenThumbs(from: .init(x: sliderViewXCenter, y: sliderViewYCenter), to: .init(x: thumbLocation, y: sliderViewYCenter))
                
                // Thumb Handle
                let thumbPoint = CGPoint(x: thumbLocation, y: sliderViewYCenter)
                thumbView(position: thumbPoint, value: Float(currentValue.wrappedValue))
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(max(dragLocation.x, 0), sliderSize.width)
                        
                        // Calculate newValue based on drag offset
                        let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)
                        let clampedValue = min(max(newValue, Float(sliderBounds.lowerBound)), Float(sliderBounds.upperBound)) // Clamp value to slider range
                        currentValue.wrappedValue = Double(clampedValue)
                        
                        sliderViewX = sliderSize.width / 2
                        
                    })
            }
        }
    }
    
    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(Colors.deepBlue, style: StrokeStyle(lineWidth: 16, lineCap: .round))
    }
    
    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
        let isCenter = position.x == sliderViewX
        let circleColor = isCenter ? Colors.deepBlue : Color.white
        
        ZStack {
            Circle()
                .frame(width: 12, height: 12)
                .foregroundColor(circleColor)
                .contentShape(Rectangle())
                .offset(x: value == 0 ? 0 : position.x < sliderViewX ? 8 : -8, y: 0)
        }
        .position(x: position.x, y: position.y)
    }
}
