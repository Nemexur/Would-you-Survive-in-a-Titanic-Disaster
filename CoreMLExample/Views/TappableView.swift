//
//  TappableView.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 23/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

enum TouchesState {
    case began
    case moved
    case ended
}

class TappableView: UIView {
    
    private let image: UIImage?
    private let gradientColors: [UIColor]
    private var touchesState: TouchesState = .began
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public init(image: UIImage? = nil, gradientColors: [UIColor], frame: CGRect = .zero) {
        self.image = image
        self.gradientColors = gradientColors
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setGradient(with: gradientColors, direction: .fromLeftBottom)
        if image != nil {
            self.addSubview(buttonImageView)
            buttonImageView.autoPinEdgesToSuperView(self)
            buttonImageView.applyImage(image: image, tintColor: .black)
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesState = .began
        animateTap()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchesState == .began {
            touchesState = .ended
            animateTap()
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchesState == .began {
            touchesState = .ended
            animateTap()
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchesState == .began {
            touchesState = .ended
            animateTap()
        }
    }
    
    private func animateTap() {
        switch touchesState {
        case .began:
            UIView.animate(withDuration: .animation200ms) { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransform(scaleX: 0.82, y: 0.82)
            }
        case .ended:
            UIView.animate(withDuration: .animation200ms) { [weak self] in
                guard let self = self else { return }
                self.transform = CGAffineTransform.identity
            }
        case .moved:
            break
        }
    }
}
