//
//  CGAffineTransform+Extensions.swift
//  Pictoria
//
//  Created by ANTON DOBRYNIN on 17.05.2024.
//

import UIKit


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
