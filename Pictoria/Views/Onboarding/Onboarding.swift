//
//  Onboarding.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI

struct Onboarding: View {
    
    @Environment(\.presentationMode) var presentationMode
    var onClose: (() -> Void)
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("Here’s Pictoria\nfeatures!")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundStyle(Colors.blacker)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .multilineTextAlignment(.center)
                
                // 1
                VStack {
                    Image("onboarding_fillters_ic")
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Filter&Lights.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Improve your photos with a range of filters and make precise adjustments to the lighting. Select from a wide selection of presets or fine-tune the settings to achieve a personalized appearance.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 2
                VStack {
                    Image("onboarding_text_ic")
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Soon: Text.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Include text on your photos using a range of fonts, sizes, and colors. Generate captions, quotes, or memes to communicate your message to a larger audience.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 3
                VStack {
                    Image("onboarding_corners_ic")
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Corners&Vignette.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Give your photos a distinct look by rounding or sharpening their corners. Opt for a soft, rounded edge to achieve a vintage appearance, or keep them sharp for a modern vibe.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 4
                VStack {
                    Image("onboarding_stickers_ic")
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Soon: Stickers.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Customize your photos using a variety of enjoyable stickers and emojis. Whether it's holiday-themed stickers or emojis, there is an option for every event to add a personal touch.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 5
                VStack {
                    Image("onboarding_draw_ic")
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Soon: Draw.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Showcase your artistic side by sketching directly on your photos using a range of brush styles and colors. Enhance your pictures by adding annotations, highlights, or doodles to give them a unique touch.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 6
                VStack {
                    Image("onboarding_transform_ic")
                        .resizable()
                        .frame(width: 300, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Transform.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Adjust the orientation, mirror, or tilt your photos to create unique visual impacts. Play around with diverse angles and viewpoints to infuse energy and movement into your images.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 7
                VStack {
                    Image("onboarding_crop_ic")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Crop.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Trim your pictures to highlight key elements or modify the ratio. Effortlessly eliminate unnecessary aspects or craft captivating arrangements.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
                
                // 8
                VStack {
                    Image("onboarding_resize_ic")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .padding(.top, 12)
                    
                    VStack {
                        Text("Resize.")
                            .foregroundColor(Colors.blacker)
                            .font(.system(size: 14, weight: .bold))
                        + Text(" Resize your images to suit any frame or social media platform. Whether you're sharing on Instagram or creating a poster, we have the solution for you.")
                            .foregroundColor(Colors.deepGray)
                            .font(.system(size: 14, weight: .light))
                    }
                    .padding(.horizontal, 12)
                    
                    Image("onboarding_button_arror")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.vertical, 12)
                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Colors.lightGray, lineWidth: 1)
                )
                .onTapGesture {
                    onClose()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 80)
        }
    }
}
