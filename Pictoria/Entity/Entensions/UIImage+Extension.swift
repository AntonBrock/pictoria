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
        
        guard let cgImage = self.cgImage else {
            return nil
        }
        
        let radians = CGFloat(rotationAngle.radians)
        
        // Вычисляем новый размер с учетом ориентации
        var newSize = self.size
        if abs(rotationAngle.degrees).truncatingRemainder(dividingBy: 180) == 90 {
            newSize = CGSize(width: newSize.height, height: newSize.width)
        }
        
        // Новый контекст для рисования с учетом ориентации и зеркального отражения
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        // Применяем преобразования
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        context.rotate(by: radians)
        context.scaleBy(x: isHorizontalMirrored ? -1.0 : 1.0, y: isVerticalMirrored ? -1.0 : 1.0)
        context.draw(cgImage, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        // Получаем измененное изображение
        let transformedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return transformedImage
    }
}
