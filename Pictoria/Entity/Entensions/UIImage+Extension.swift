//
//  UIImage+Extension.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 17.05.2024.
//

import UIKit
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

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
