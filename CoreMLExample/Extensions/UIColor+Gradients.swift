//
//  UIColor+Gradients.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

enum Gradients {
    static let mainViewGradient      = [UIColor(hex: 0x232526), UIColor(hex: 0x414345)]
    static let clearButtonGradient   = [UIColor(hex: 0xde6262), UIColor(hex: 0xffb88c)]
    static let predictDigitsGradient = [UIColor(hex: 0x5f72bd), UIColor(hex: 0x9b23ea)]
    static let nexAndFinishGradient  = [UIColor(hex: 0xff512f), UIColor(hex: 0xf09819)]
}

extension UIColor {
    static let whiteAlpha0  = UIColor.white.withAlphaComponent(0)
    static let whiteAlpha10 = UIColor.white.withAlphaComponent(0.1)
    static let whiteAlpha20 = UIColor.white.withAlphaComponent(0.2)
    static let whiteAlpha30 = UIColor.white.withAlphaComponent(0.3)
    static let whiteAlpha40 = UIColor.white.withAlphaComponent(0.4)
    static let whiteAlpha50 = UIColor.white.withAlphaComponent(0.5)
    static let whiteAlpha60 = UIColor.white.withAlphaComponent(0.6)
    static let whiteAlpha70 = UIColor.white.withAlphaComponent(0.7)
    static let whiteAlpha80 = UIColor.white.withAlphaComponent(0.8)
    static let whiteAlpha90 = UIColor.white.withAlphaComponent(0.9)
    
    static let blackAlpha0  = UIColor.black.withAlphaComponent(0)
    static let blackAlpha10 = UIColor.black.withAlphaComponent(0.1)
    static let blackAlpha20 = UIColor.black.withAlphaComponent(0.2)
    static let blackAlpha30 = UIColor.black.withAlphaComponent(0.3)
    static let blackAlpha40 = UIColor.black.withAlphaComponent(0.4)
    static let blackAlpha50 = UIColor.black.withAlphaComponent(0.5)
    static let blackAlpha60 = UIColor.black.withAlphaComponent(0.6)
    static let blackAlpha70 = UIColor.black.withAlphaComponent(0.7)
    static let blackAlpha80 = UIColor.black.withAlphaComponent(0.8)
    static let blackAlpha90 = UIColor.black.withAlphaComponent(0.9)
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
