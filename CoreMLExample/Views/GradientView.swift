//
//  GradientView.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

class GradientView: UIView {
    
    enum Direction {
        case vertical
        case horizontal
        case fromLeftBottom
        case fromLeftTop
    }
    
    open override class var layerClass: Swift.AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientColors: [UIColor] = [] {
        didSet {
            guard let gradient = layer as? CAGradientLayer else { return }
            gradient.colors = gradientColors.compactMap { $0.cgColor }
        }
    }
    
    var direction: Direction = .horizontal {
        didSet {
            guard let gradient = layer as? CAGradientLayer else { return }
            switch direction {
            case .horizontal:
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 0)
            case .vertical:
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 0, y: 1)
            case .fromLeftBottom:
                gradient.startPoint = CGPoint(x: 0, y: 1)
                gradient.endPoint = CGPoint(x: 1, y: 0)
            case .fromLeftTop:
                gradient.startPoint = CGPoint(x: 0, y: 0)
                gradient.endPoint = CGPoint(x: 1, y: 1)
            }
        }
    }
}
