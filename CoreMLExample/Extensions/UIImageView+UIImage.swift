//
//  UIImageView+UIImage.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 22/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static let nextIcon =   UIImage(named: "NextIcon")?.withRenderingMode(.alwaysTemplate)
    static let okIcon =     UIImage(named: "OKIcon")?.withRenderingMode(.alwaysTemplate)
    static let clearIcon =  UIImage(named: "ClearIcon")?.withRenderingMode(.alwaysTemplate)
    static let digitsIcon = UIImage(named: "PredictDigitsIcon")?.withRenderingMode(.alwaysTemplate)
}

private extension Int {
    static let bitsPerComponent: Int = 8
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        guard self.size != size else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func getPixelBuffer() -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        let width = Int(size.width)
        let height = Int(size.height)
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
        guard let buffer = pixelBuffer else { return nil }
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        let colorspace = CGColorSpaceCreateDeviceGray()
        guard let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(buffer), width: width, height: height, bitsPerComponent: .bitsPerComponent, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer), space: colorspace, bitmapInfo: 0) else { return nil }
        guard let cgImage = self.cgImage else { return nil }
        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return buffer
    }
    
    func processImageForPrediction(with size: CGSize) -> CVPixelBuffer? {
        return self.resize(to: size)?.getPixelBuffer()
    }
}

extension UIImageView {
    func applyImage(image: UIImage?, tintColor: UIColor = .black) {
        alpha = 0
        self.image = image
        self.tintColor = tintColor
        UIView.animate(withDuration: .animation300ms) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
        }
    }
}
