//
//  NextAndFinishButton.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

final class NextAndFinishButton: TappableView {
    
    enum NextAndFinishButtonState {
        case next
        case finish
    }
    
    // UI
    private var buttonImage: UIImage? = .nextIcon {
        didSet {
            if buttonImage != oldValue {
                buttonImageView.applyImage(image: buttonImage)
            }
        }
    }
    
    private lazy var buttonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Models
    var buttonState: NextAndFinishButtonState = .next {
        didSet {
            if buttonState != oldValue {
                switch buttonState {
                case .next:
                    buttonImage = .nextIcon
                case .finish:
                    buttonImage = .okIcon
                }
            }
        }
    }
    
    private let gradientColors: [UIColor]
    
    // MARK: - Init
    
    override init(image: UIImage? = nil, gradientColors: [UIColor], frame: CGRect = .zero) {
        self.gradientColors = gradientColors
        super.init(image: image, gradientColors: gradientColors, frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func setupUI() {
        addSubview(buttonImageView)
        buttonImageView.autoPinEdgesToSuperView(self)
        buttonImageView.applyImage(image: buttonImage)
    }
}
