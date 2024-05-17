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
                
                
                let thumbLocation = CGFloat(currentValue.wrappedValue) * stepWidthInPixel
                
                // Path between starting point to thumb
                lineBetweenThumbs(from: .init(x: sliderViewXCenter, y: sliderViewYCenter), to: .init(x: thumbLocation, y: sliderViewYCenter))
                
                // Thumb Handle
                let thumbPoint = CGPoint(x: thumbLocation, y: sliderViewYCenter)
                thumbView(position: thumbPoint, value: Float(currentValue.wrappedValue))
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        
                        let dragLocation = dragValue.location
                        let xThumbOffset = min(dragLocation.x, sliderSize.width)
                        
                        let newValue = Float(sliderBounds.lowerBound / sliderBounds.upperBound) + Float(xThumbOffset / stepWidthInPixel)
                        if newValue > Float(sliderBounds.lowerBound) && newValue < Float(sliderBounds.upperBound + 1) {
                            currentValue.wrappedValue = Double(newValue)
                            sliderViewX = sliderSize.width / 2
                        }
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
                .offset(x: value == 50 ? 0 : position.x < sliderViewX ? 8 : -8, y: 0)
        }
        .position(x: position.x, y: position.y)
    }
}
