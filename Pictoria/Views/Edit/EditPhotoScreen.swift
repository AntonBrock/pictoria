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
    @State private var hue: Double = 0.05
    @State private var saturation: Double = 1.0
    @State private var brightness: Double = 0.0
    
    // Resize
    @State private var selectedAspectRatio: AspectRatio = .none
    
    // Transformation
    @State private var rotationAngle: Angle = .zero
    @State private var isHorizontalMirrored: Bool = false
    @State private var isVerticalMirrored: Bool = false

    // Corners
    @State private var rounded: Double = 0.05
    
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
                                .cornerRadius(rounded)
                                .clipped()
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
                .padding(.bottom, 80)
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
                            let roundedImage = resizedImage.roundedImage(withRadius: rounded)
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
            HStack {
                Text("Hue")
                    .font(.system(size: 17))
                    .foregroundStyle(Colors.blacker)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Colors.middleGray)
                    .frame(width: 30, height: 16)
                    .overlay {
                        Text("\(hue, specifier: "%.2f")")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.deepBlue)
                    }
            }
            
            CustomSlider(value: $hue) // inRange: -1.0...1.0
            .onChange(of: hue) { _ in applyFilters() }
            .padding(.top, 3)
            
            HStack {
                Text("Saturation")
                    .font(.system(size: 17))
                    .foregroundStyle(Colors.blacker)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Colors.middleGray)
                    .frame(width: 30, height: 16)
                    .overlay {
                        Text("\(saturation, specifier: "%.2f")")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.deepBlue)
                    }
            }
            
            CustomSlider(value: $saturation) // inRange: -0.0...2.0
            .onChange(of: saturation) { _ in applyFilters() }
            .padding(.top, 3)

            HStack {
                Text("Lightness")
                    .font(.system(size: 17))
                    .foregroundStyle(Colors.blacker)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 14)
                    .fill(Colors.middleGray)
                    .frame(width: 30, height: 16)
                    .overlay {
                        Text("\(brightness, specifier: "%.2f")")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.deepBlue)
                    }
            }
            
            CustomSlider(value: $brightness) //inRange: -1.0...1.0

            .onChange(of: brightness) { _ in applyFilters() }
            .padding(.top, 3)

        }
        .padding()
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
    
    #warning("TODO: Нужно будет сделать так чтобы при нажатие повторялся эффект а не был 1 раз")
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
                    .frame(width: 30, height: 16)
                    .overlay {
                        Text("\(rounded, specifier: "%.2f")")
                            .font(.system(size: 11))
                            .foregroundStyle(Colors.deepBlue)
                    }
            }
            
            CustomSlider(value: $rounded) //inRange: 0...100
                .onChange(of: rounded) { newValue in
                    self.rounded = newValue
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

#warning("TODO: Вынести в другой файл")
extension CGAffineTransform {
    var rotationAngle: CGFloat {
        return atan2(b, a)
    }

    var scaleX: CGFloat {
        return sqrt(a * a + c * c)
    }

    var scaleY: CGFloat {
        return sqrt(b * b + d * d)
    }
}

extension UIImage {
    func roundedImage(withRadius radius: CGFloat) -> UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = radius
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0 // Устанавливаем толщину рамки, если требуется
        imageView.layer.borderColor = UIColor.clear.cgColor // Устанавливаем цвет рамки, если требуется

        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func applyTransformation(_ rotationAngle: Angle,
                             _ isHorizontalMirrored: Bool,
                             _ isVerticalMirrored: Bool)
    -> UIImage? {
        var transform = CGAffineTransform.identity
        var newSize = self.size
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let rotationAngle = CGFloat(rotationAngle.radians)
        transform = transform.rotated(by: rotationAngle)
        newSize = CGSize(width: size.height, height: size.width)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        if isHorizontalMirrored {
            context.translateBy(x: newSize.width, y: 0)
        }
        
        if isVerticalMirrored {
            context.translateBy(x: 0, y: newSize.height)
        }
        
        context.concatenate(transform)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        context.draw(cgImage, in: rect)
        
        let transformedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return transformedImage
    }
}

struct CustomSlider: View {
    @Binding var value: Double
//    var inRange: ClosedRange<Double>

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
                            .frame(width: CGFloat(value) * geometry.size.width, height: 16)
                            .animation(.linear, value: value)
                        
                        // Slider circle
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 12, height: 12)
                            .offset(x: CGFloat(value) * geometry.size.width - 15, y: 0)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        let newValue = gesture.location.x / geometry.size.width
                                        self.value = min(max(0, newValue), 1)
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
