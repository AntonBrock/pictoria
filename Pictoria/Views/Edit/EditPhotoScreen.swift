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
    
    @Binding var selectedImage: UIImage?

    var didSave: (() -> Void)
    
    // Filters
    @State private var hue: Double = 50
    @State private var saturation: Double = 50
    @State private var brightness: Double = 50
    
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
                                .rotationEffect(rotationAngle)
                                .scaleEffect(x: isHorizontalMirrored ? -1 : 1, y: 1)
                                .scaleEffect(y: isVerticalMirrored ? -1 : 1)
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
                        }  else {
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
                                    selectedAspectRatio = .none
                                    rounded = 0
                                    rotationAngle = .zero
                                    isVerticalMirrored = false
                                    isHorizontalMirrored = false
                                    
                                    transformChoosed = false
                                    resizeChoosed = false
                                    isFilterAndLightsChoosed = false
                                    cornersChoosed = false
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
                                }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .opacity(isFilterAndLightsChoosed || resizeChoosed || transformChoosed || cornersChoosed ? 1 : 0)
                        
                        Spacer()
                    }
                    .navigationTitle("All Features")
                    .navigationBarTitleDisplayMode(.inline)
                    
                }
                .padding(.bottom, 20)
            }
            .navigationBarItems(
                trailing: Button(action: {
                    
                    withAnimation {
                        isLoading = true
                    }
                    
                    if let selectedImage = selectedImage,
                       let transformedImage = selectedImage.applyTransformation(rotationAngle, isHorizontalMirrored, isVerticalMirrored)
                    {
                        
                        let aspectRatio = selectedAspectRatio.size(for: transformedImage.size.width)
                        if let resizedImage = transformedImage.resize(to: aspectRatio) {
                            let roundedImage = resizedImage.roundedImage(withRadius: CGFloat(rounded))
                            if let finalImage = roundedImage {
                                
                                UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
                                
                                var images: [UIImage] = []
                                
                                if let userDefaultsImages = UserDefaults.standard.array(forKey: "ImagesProjects") as? [Data] {
                                    for imageData in userDefaultsImages {
                                        if let image = UIImage(data: imageData) {
                                            images.append(image)
                                        }
                                    }
                                }
                                
                                images.append(finalImage)
                                
                                let imageDataArray = images.compactMap { $0.pngData() }
                                UserDefaults.standard.set(imageDataArray, forKey: "ImagesProjects")
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    didSave()
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
                
                SliderViewWithRange(value: $hue, bounds: 1...100)
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
                            Text("\(saturation, specifier: "%.2f")")
                                .font(.system(size: 11))
                                .foregroundStyle(Colors.deepBlue)
                        }
                }
                
                SliderViewWithRange(value: $saturation, bounds: 1...100)
                    .onChange(of: saturation) { _ in applyFilters() }
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
                
                SliderViewWithRange(value: $brightness, bounds: 1...100)
                    .onChange(of: brightness) { _ in applyFilters() }
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
    
    private func applyFilters() {
        guard let inputImage = CIImage(image: selectedImage!) else { return }
        
        DispatchQueue.main.async {
            let context = CIContext()
            let filter = CIFilter.colorControls()
            filter.inputImage = inputImage
            filter.saturation = Float(saturation)
            filter.brightness = Float(brightness)
            
            let hueAdjust = CIFilter.hueAdjust()
            hueAdjust.inputImage = filter.outputImage
            hueAdjust.angle = Float(hue) * Float.pi
            
            guard let outputImage = hueAdjust.outputImage,
                  let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
            
            self.selectedImage = UIImage(cgImage: cgImage)
        }
    }
}

//extension View {
//    func applyTransformation(_ transformation: ImageTransformation?) -> some View {
//        var transform: CGAffineTransform = .identity
//        
//        if let transformation = transformation {
//            switch transformation {
//            case .rotateClockwise:
//                transform = transform.rotated(by: .pi / 2)
//            case .rotateCounterClockwise:
//                transform = transform.rotated(by: -.pi / 2)
//            case .mirrorHorizontal:
//                transform = transform.scaledBy(x: -1, y: 1)
//            case .mirrorVertical:
//                transform = transform.scaledBy(x: 1, y: -1)
//            case .none: transform = .identity
//            }
//        }
//    
//        return self
//            .rotationEffect(Angle(radians: transform.rotationAngle))
//            .scaleEffect(x: transform.scaleX, y: transform.scaleY)
//    }
//}

