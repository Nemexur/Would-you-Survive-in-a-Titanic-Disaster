//
//  CanvasView.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 22/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private extension CGFloat {
    static let lineWidth: CGFloat = 10
}

final class CanvasView: UIView {
    
    enum CanvasViewState {
        case cleaned
        case drawing
    }
    
    // UI
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black
        return imageView
    }()
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    // Models
    var state: CanvasViewState = .cleaned
    private var touchesState: TouchesState = .began
    private var lastPoint: CGPoint = .zero
    
    // MARK: - Init
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Configure UI
    
    private func setupUI() {
        addSubview(imageView)
        imageView.autoPinEdgesToSuperView(self)
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesState = .began
        state = .drawing
        guard let touch = touches.first else { return }
        lastPoint = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesState = .moved
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        performDrawing(from: lastPoint, to: currentPoint)
        lastPoint = currentPoint
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touchesState == .began else { return }
        performDrawing(from: lastPoint, to: lastPoint)
    }
    
    // MARK: - Drawing
    
    func performDrawing(from startPoint: CGPoint, to endPoint: CGPoint) {
        defer { UIGraphicsEndImageContext() }
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        let currentContext = UIGraphicsGetCurrentContext()
        imageView.image?.draw(in: .init(origin: .zero, size: frame.size))
        currentContext?.setLineCap(.round)
        currentContext?.setLineWidth(.lineWidth)
        currentContext?.setStrokeColor(UIColor.white.cgColor)
        currentContext?.setBlendMode(.normal)
        currentContext?.move(to: startPoint)
        currentContext?.addLine(to: endPoint)
        currentContext?.strokePath()
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
    }
}
