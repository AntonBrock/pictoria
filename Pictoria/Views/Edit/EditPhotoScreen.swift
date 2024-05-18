//
//  EditPhotoScreen.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 13.05.2024.
//

import SwiftUI
import SwiftyCrop
import CoreImage
import CoreImage.CIFilterBuiltins

enum AspectRatio: String, CaseIterable, Identifiable {
    case oneToOne = "1:1"
    case threeToFour = "3:4"
    case fourToThree = "4:3"
    case sixteenToNine = "16:9"
    case nineToSixteen = "9:16"
    case twoToThree = "2:3"
    case threeToTwo = "3:2"
    case none

    var id: String { self.rawValue }

    func size(for width: CGFloat) -> CGSize {
        switch self {
        case .oneToOne:
            return CGSize(width: width, height: width)
        case .threeToFour:
            return CGSize(width: width, height: width * 4 / 3)
        case .fourToThree:
            return CGSize(width: width, height: width * 3 / 4)
        case .sixteenToNine:
            return CGSize(width: width, height: width * 9 / 16)
        case .nineToSixteen:
            return CGSize(width: width, height: width * 16 / 9)
        case .twoToThree:
            return CGSize(width: width, height: width * 3 / 2)
        case .threeToTwo:
            return CGSize(width: width, height: width * 2 / 3)
        case .none:
            return CGSize(width: 358, height: 412)
        }
    }
}

struct EditPhotoScreen: View {
    
    @State var isFilterAndLightsChoosed: Bool = false
    @State var resizeChoosed: Bool = false
    @State var transformChoosed: Bool = false
    @State var cornersChoosed: Bool = false
    @State var isLoading: Bool = false
    
    @State var originalImage: UIImage?
    @Binding var selectedImage: UIImage?

    var didSave: (() -> Void)
    
    // Filters
    @State private var hue: Double = 0
    @State private var saturation: Double = 0
    @State private var brightness: Double = 0
    
    // Resize
    @State private var selectedAspectRatio: AspectRatio = .none
    
    // Transformation
    @State private var rotationAngle: Angle = .zero
    @State private var isHorizontalMirrored: Bool = false
    @State private var isVerticalMirrored: Bool = false

    // Corners
    @State private var rounded: Int = 0
    
    // Crop
    @State private var selectedShape: MaskShape = .square
    @State private var showImageCropper: Bool = false
    
    @State private var cropImageCircular: Bool = false
    @State private var rotateImage: Bool = true
    @State private var maxMagnificationScale: CGFloat = 4.0
    @State private var maskRadius: CGFloat = 130
    @State private var zoomSensitivity: CGFloat = 1

    // Vignette
    @State private var vignetteChoosed: Bool = false
//    @State private var vignetteValue: Int = 0
    
    @State private var intensity: Int = 1
//    @State private var radius: Int = 5
    
    // Blocked
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - 32
                let size = selectedAspectRatio.size(for: availableWidth)
                
                ScrollView(.vertical) {
                    VStack {
                        ZStack {
                            Image(uiImage: selectedImage ?? UIImage())
                                .resizable()
                                .scaledToFill()
                                .frame(width: size.width, height: size.height)
                                .clipped()
                                .cornerRadius(CGFloat(rounded))
                                .padding(.top, 32)
                                .padding(.horizontal, 16)
                        }
                        .frame(width: geometry.size.width)
                        .clipped()
                        
                        if isFilterAndLightsChoosed {
                            filltersAndLigh()
                        } else if resizeChoosed {
                            resize()
                        } else if transformChoosed {
                            transform()
                        } else if cornersChoosed {
                            corners()
                        } else if vignetteChoosed {
                            vignette()
                        } else {
                            ScrollView(.horizontal) {
                                HStack(spacing: 16) {
                                    // 1
                                    VStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Colors.middleGray)
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image("edit_ic")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                        
                                        Text("Filter & Lights")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        isFilterAndLightsChoosed = true
                                    }
                                    
                                    // 2
                                    VStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Colors.middleGray)
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image("resize_ic")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                        
                                        Text("Resize")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        resizeChoosed = true
                                    }
                                    
                                    VStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Colors.middleGray)
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image("crop_ic")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                        
                                        Text("Crop")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        showImageCropper = true
                                    }
                                    
                                    // 4
                                    VStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Colors.middleGray)
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image("transform_ic")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                        
                                        Text("Transform")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        transformChoosed = true
                                    }
                                    
                                    // 6
                                    VStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Colors.middleGray)
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image("corners_ic")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                        
                                        Text("Corners")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        cornersChoosed = true
                                    }
                                    
                                    // 7
                                    VStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Colors.middleGray)
                                            .frame(width: 56, height: 56)
                                            .overlay {
                                                Image("vignette_ic")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                            }
                                        
                                        Text("Vignette")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        vignetteChoosed = true
                                    }
                                    
                                    // 8
                                    VStack {
                                        
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Colors.middleGray)
                                                .frame(width: 56, height: 56)
                                                .overlay {
                                                    Image("text_ic")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                }
                                            
                                            
                                            Image("lock_ic")
                                                .resizable()
                                                .frame(width: 23, height: 23)
                                                .padding(.top, 35)
                                                .padding(.trailing, -40)
                                        }
                                        
                                        Text("Text")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        showAlert.toggle()
                                    }
                                    
                                    // 9
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Colors.middleGray)
                                                .frame(width: 56, height: 56)
                                                .overlay {
                                                    Image("stickers_ic")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                }
                                            
                                            Image("lock_ic")
                                                .resizable()
                                                .frame(width: 23, height: 23)
                                                .padding(.top, 35)
                                                .padding(.trailing, -40)
                                        }
                                        
                                        Text("Stickers")
                                            .foregroundColor(Color.black)
                                            .font(.system(size: 12, weight: .medium))
                                            .fixedSize(horizontal: true, vertical: false)
                                            .padding(.horizontal, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                    .onTapGesture {
                                        showAlert.toggle()
                                    }
                                }
                                
                                .padding(.top, 16)
                            }
                            .scrollIndicators(.hidden)
                            .frame(height: 90)
                            .padding(.horizontal, 16)
                        }
                        
                        HStack {
                            Image("cancel_ic")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .onTapGesture {
                                    if resizeChoosed {
                                        selectedAspectRatio = .none
                                    }
                                    
                                    if vignetteChoosed {
//                                        intensity = 0
                                        intensity = 0
                                    }
                                    
                                    if isFilterAndLightsChoosed {
                                        hue = 0
                                        brightness = 0
                                        saturation = 0
                                    }
                                    
                                    if cornersChoosed {
                                        rounded = 0
                                    }
                                    
                                    if transformChoosed {
                                        rotationAngle = .zero
                                        isVerticalMirrored = false
                                        isHorizontalMirrored = false
                                    }
                                    
                                    transformChoosed = false
                                    resizeChoosed = false
                                    isFilterAndLightsChoosed = false
                                    cornersChoosed = false
                                    vignetteChoosed = false
                                    
                                    self.selectedImage = self.originalImage
                                }
                            
                            Spacer()
                            
                            Image("approve_ic")
                                .resizable()
                                .frame(width: 44, height: 44)
                                .onTapGesture {
                                    transformChoosed = false
                                    resizeChoosed = false
                                    isFilterAndLightsChoosed = false
                                    cornersChoosed = false
                                    vignetteChoosed = false
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .opacity(isFilterAndLightsChoosed || resizeChoosed || transformChoosed || cornersChoosed || vignetteChoosed ? 1 : 0)
                        
                        Spacer()
                    }
                    .navigationTitle("All Features")
                    .navigationBarTitleDisplayMode(.inline)
                    
                }
                .padding(.bottom, 20)
            }
            .onChange(of: rotationAngle) { _ in
                if let selectedImage = selectedImage {
                    self.selectedImage = selectedImage.applyTransformation(rotationAngle, isHorizontalMirrored, isVerticalMirrored)
                }
            }
            .onChange(of: isHorizontalMirrored) { _ in
                if let selectedImage = selectedImage {
                    self.selectedImage = selectedImage.applyTransformation(rotationAngle, isHorizontalMirrored, isVerticalMirrored)
                }
            }
            .onChange(of: isVerticalMirrored) { _ in
                if let selectedImage = selectedImage {
                    self.selectedImage = selectedImage.applyTransformation(rotationAngle, isHorizontalMirrored, isVerticalMirrored)
                }
            }
            .navigationBarItems(
                trailing: Button(action: {
                    
                    withAnimation {
                        isLoading = true
                    }
                    
                    let group = DispatchGroup()
                    
                    if let selectedImage = selectedImage {
                        let aspectRatio = selectedAspectRatio.size(for: selectedImage.size.width)
                        if let resizedImage = selectedImage.resize(to: aspectRatio) {
                            let roundedImage = resizedImage.roundedImage(withRadius: CGFloat(rounded))
                            if let finalImage = roundedImage {
                                
                                saveToCashImage(uiImage: finalImage, group: group)
                                
                                group.notify(queue: .main) {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        didSave()
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Save")
                }
            )
            .fullScreenCover(isPresented: $showImageCropper) {
                if let selectedImage = selectedImage {
                    SwiftyCropView(
                        imageToCrop: selectedImage,
                        maskShape: selectedShape,
                        configuration: SwiftyCropConfiguration(
                            maxMagnificationScale: maxMagnificationScale,
                            maskRadius: maskRadius,
                            cropImageCircular: cropImageCircular,
                            rotateImage: rotateImage,
                            zoomSensitivity: zoomSensitivity
                        )
                    ) { croppedImage in
                        self.selectedImage = croppedImage
                    }
                }
            }
            
            if isLoading {
                VStack {
                    ProgressView()
                        .foregroundStyle(Colors.deepBlue)
                        .padding(.bottom, 10)
                        .padding(.top, 35)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(.white.opacity(0.5))
            }
        }
        .onAppear {
            self.originalImage = self.selectedImage
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("New features will be soon!"),
                message: Text("Thank you for using Pictorial.\nIn the next version we’re realising text and stickers adding."),
                dismissButton: .default(Text("Okay"))
            )
        }
    }
    
    private func saveToCashImage(uiImage: UIImage, group: DispatchGroup) {
        DispatchQueue.global(qos: .userInitiated).async {
            group.enter()
            
            UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
            
            var images: [UIImage] = []
            
            if let userDefaultsImages = UserDefaults.standard.array(forKey: "ImagesProjects") as? [Data] {
                for imageData in userDefaultsImages {
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
            }
            
            images.append(uiImage)
            
            let imageDataArray = images.compactMap { $0.pngData() }
            UserDefaults.standard.set(imageDataArray, forKey: "ImagesProjects")
            
            group.leave()
        }
    }
    
    @ViewBuilder
    private func filltersAndLigh() -> some View {
        VStack {
            
            VStack {
                HStack {
                    Text("Hue")
                        .font(.system(size: 17))
                        .foregroundStyle(Colors.blacker)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Colors.middleGray)
                        .frame(width: 50, height: 16)
                        .overlay {
                            Text("\(hue, specifier: "%.2f")")
                                .font(.system(size: 11))
                                .foregroundStyle(Colors.deepBlue)
                        }
                }
                
                SliderViewWithRange(value: $hue, bounds: Int(-1.0)...Int(1.0))
                    .onChange(of: hue) { _ in applyFilters() }
                    .padding(.top, -5)
            }
            .padding(.top, 5)
            
            VStack {
                HStack {
                    Text("Saturation")
                        .font(.system(size: 17))
                        .foregroundStyle(Colors.blacker)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Colors.middleGray)
                        .frame(width: 50, height: 16)
                        .overlay {
                            Text("\(saturation,  specifier: "%.2f")")
                                .font(.system(size: 11))
                                .foregroundStyle(Colors.deepBlue)
                        }
                }

                SliderViewWithRange(value: $saturation, bounds: Int(-1.0)...Int(1.0))
                    .onChange(of: saturation) { _ in applyFilterSaturation() }
                    .padding(.top, -5)
            }
            .padding(.top, 5)

            VStack {
                HStack {
                    Text("Lightness")
                        .font(.system(size: 17))
                        .foregroundStyle(Colors.blacker)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Colors.middleGray)
                        .frame(width: 50, height: 16)
                        .overlay {
                            Text("\(brightness, specifier: "%.2f")")
                                .font(.system(size: 11))
                                .foregroundStyle(Colors.deepBlue)
                        }
                }
                
                SliderViewWithRange(value: $brightness, bounds: Int(-1.0)...Int(1.0))
                    .onChange(of: brightness) { _ in applyFiltersBrightness() }
                    .padding(.top, -5)
            }
            .padding(.top, 5)

        }
        .padding()
        .padding(.bottom, -10)
    }
    
    @ViewBuilder
    private func resize() -> some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                // 1
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .oneToOne ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("oneToOne_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .oneToOne ? .white : Colors.deepBlue)
                            
                            Text("1:1")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .oneToOne ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .oneToOne
                    }
                
                // 2
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .threeToFour ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("threeToFour_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .threeToFour ? .white : Colors.deepBlue)
                            
                            Text("3:4")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .threeToFour ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .threeToFour
                    }
                
                // 3
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .fourToThree ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("fourToThree_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .fourToThree ? .white : Colors.deepBlue)
                            
                            Text("4:3")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .fourToThree ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .fourToThree
                    }
                
                // 4
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .sixteenToNine ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("sixteenToNine_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .sixteenToNine ? .white : Colors.deepBlue)
                            
                            Text("16:9")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .sixteenToNine ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .sixteenToNine
                    }
                
                // 5
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .nineToSixteen ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("nineToSixteen_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .nineToSixteen ? .white : Colors.deepBlue)
                            
                            Text("9:16")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .nineToSixteen ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .nineToSixteen
                    }
                
                // 6
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .twoToThree ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("twoToThree_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .twoToThree ? .white : Colors.deepBlue)
                            
                            Text("2:3")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .twoToThree ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .twoToThree
                    }
                
                // 7
                RoundedRectangle(cornerRadius: 14)
                    .fill(selectedAspectRatio == .threeToTwo ? Colors.deepBlue : Colors.middleGray)
                    .frame(width: 48, height: 71)
                    .overlay {
                        VStack {
                            Image("threeToTwo_ic")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedAspectRatio == .threeToTwo ? .white : Colors.deepBlue)
                            
                            Text("3:2")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundStyle(selectedAspectRatio == .threeToTwo ? .white : Colors.deepBlue)
                        }
                    }
                    .onTapGesture {
                        selectedAspectRatio = .threeToTwo
                    }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func transform() -> some View {
        HStack(spacing: 8) {
            // 1
            RoundedRectangle(cornerRadius: 14)
                .fill(Colors.middleGray)
                .frame(width: 48, height: 48)
                .overlay {
                    VStack {
                        Image("rotate_left_ic")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .onTapGesture {
                    withAnimation {
                        rotationAngle += .degrees(-90)
                    }
                }
            
            // 2
            RoundedRectangle(cornerRadius: 14)
                .fill(Colors.middleGray)
                .frame(width: 48, height: 48)
                .overlay {
                    VStack {
                        Image("rotate_right_ic")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                    }
                }
                .onTapGesture {
                    withAnimation {
                        rotationAngle += .degrees(90)
                    }
                }
            
            // 3
            RoundedRectangle(cornerRadius: 14)
                .fill(Colors.middleGray)
                .frame(width: 48, height: 48)
                .overlay {
                    VStack {
                        Image("mirror_horizontal_ic")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .onTapGesture {
                    isHorizontalMirrored.toggle()
                }
            
            // 4
            RoundedRectangle(cornerRadius: 14)
                .fill(Colors.middleGray)
                .frame(width: 48, height: 71)
                .overlay {
                    VStack {
                        Image("mirror_vertical_ic")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .onTapGesture {
                    isVerticalMirrored.toggle()
                }
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func corners() -> some View {
        VStack {
            HStack {
                Text("Corners")
                    .font(.system(size: 17))
                    .foregroundStyle(Colors.blacker)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Colors.middleGray)
                    .frame(width: 50, height: 16)
                    .overlay {
                        Text("\(rounded)")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.deepBlue)
                    }
            }
            
            CustomSlider(value: $rounded)
                .onChange(of: rounded) { newValue in
                    withAnimation {
                        self.rounded = newValue
                    }
                }
            .padding(.top, 3)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    @ViewBuilder
    private func vignette() -> some View {
        VStack {
            HStack {
                Text("Vignette")
                    .font(.system(size: 17))
                    .foregroundStyle(Colors.blacker)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Colors.middleGray)
                    .frame(width: 50, height: 16)
                    .overlay {
                        Text("\(intensity)")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.deepBlue)
                    }
            }
            
            CustomSlider(value: $intensity)
                .onChange(of: intensity) { _ in
                    guard let originalImage = originalImage else {
                        return
                    }
                    withAnimation {
                        selectedImage = originalImage
                        applyVignetteFilter()
                    }
                }
                .padding(.top, -5)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)

    }
    
    private func applyFilters() {
        guard let inputImage = CIImage(image: selectedImage!) else { return }
        
        DispatchQueue.main.async {
            let context = CIContext()
            let filter = CIFilter.colorControls()
            
            filter.inputImage = inputImage
            
            let hueAdjust = CIFilter.hueAdjust()
            hueAdjust.inputImage = filter.outputImage
            hueAdjust.angle = Float(hue) * Float.pi
            
            guard let outputImage = hueAdjust.outputImage,
                  let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            
            self.selectedImage = UIImage(cgImage: cgImage)
        }
    }
    
    private func applyFilterSaturation() {
        guard let inputImage = CIImage(image: selectedImage!) else { return }
        
        let context = CIContext()
        let filter = CIFilter.colorControls()
        
        filter.inputImage = inputImage
        
        let adjustedSaturation = (saturation + 1.0)
        filter.saturation = Float(adjustedSaturation)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        DispatchQueue.main.async {
            self.selectedImage = UIImage(cgImage: cgImage)
        }
    }
    
    private func applyFiltersBrightness() {
        guard let inputImage = CIImage(image: selectedImage!) else { return }
        
        let context = CIContext()
        let filter = CIFilter(name: "CIColorControls")
                
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        
        let limitedBrightness = min(max(brightness, -0.0500), 0.0500)
        
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(Float(limitedBrightness), forKey: kCIInputBrightnessKey)
        filter?.setValue(1.0, forKey: kCIInputSaturationKey)
        filter?.setValue(1.0, forKey: kCIInputContrastKey)
        
        guard let outputImage = filter?.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        DispatchQueue.main.async {
            self.selectedImage = UIImage(cgImage: cgImage)
        }
    }
    
    private func applyVignetteFilter() {
        guard let originalImage = originalImage else {
            return
        }
        
        guard let inputImage = CIImage(image: originalImage) else {
            return
        }
        
        let context = CIContext()
        let filter = CIFilter.vignette()
        
        filter.inputImage = inputImage
                
        filter.intensity = Float(intensity / 10)
        filter.radius = 10
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return
        }
        
        DispatchQueue.main.async {
            self.selectedImage = UIImage(cgImage: cgImage)
        }
    }
}

