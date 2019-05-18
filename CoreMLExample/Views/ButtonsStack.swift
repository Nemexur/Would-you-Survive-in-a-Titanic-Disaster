//
//  ButtonsStack.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 22/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonsStackDelegate: class {
    func buttonTapped(buttonType: ButtonsStack.ButtonsStackType)
}

private extension CGFloat {
    static let buttonsHeight: CGFloat = 50
    static let separatorWidth: CGFloat = 20
}

final class ButtonsStack: UIView {
    
    enum ButtonsStackType {
        case clear
        case predict
        case nextAndFinish
    }
    
    // Dependencies
    weak var delegate: ButtonsStackDelegate?
    
    // UI
    private let clearButton = TappableView(image: .clearIcon, gradientColors: Gradients.clearButtonGradient)
    private let predictDigitButton = TappableView(image: .digitsIcon, gradientColors: Gradients.predictDigitsGradient)
    let nextAndFinishButton = NextAndFinishButton(gradientColors: Gradients.nexAndFinishGradient)
    
    private lazy var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        setupGestures()
        configureStackView()
        configureButtons()
    }
    
    private func configureStackView() {
        addSubview(stackViewContainer)
        stackViewContainer.autoPinEdgesToSuperView(self)
    }
    
    private func configureButtons() {
        stackViewContainer.addArrangedSubview(clearButton)
        clearButton.makeSimpleConstraintsAndRound(with: .buttonsHeight)
        stackViewContainer.addArrangedSubview(createEmptyView(width: .separatorWidth))
        stackViewContainer.addArrangedSubview(nextAndFinishButton)
        nextAndFinishButton.makeSimpleConstraintsAndRound(with: .buttonsHeight)
        stackViewContainer.addArrangedSubview(createEmptyView(width: .separatorWidth))
        stackViewContainer.addArrangedSubview(predictDigitButton)
        predictDigitButton.makeSimpleConstraintsAndRound(with: .buttonsHeight)
    }
    
    // MARK: - Gestures
    
    private func setupGestures() {
        let clearButtonGesture = UITapGestureRecognizer(target: self, action: #selector(clearButtonTapped))
        clearButton.addGestureRecognizer(clearButtonGesture)
        let predictDigitsGesture = UITapGestureRecognizer(target: self, action: #selector(predictDigitButtonTapped))
        predictDigitButton.addGestureRecognizer(predictDigitsGesture)
        let nextAndFinishGesture = UITapGestureRecognizer(target: self, action: #selector(nextAndFinishButtonTapped))
        nextAndFinishButton.addGestureRecognizer(nextAndFinishGesture)
    }
    
    @objc private func clearButtonTapped() {
        delegate?.buttonTapped(buttonType: .clear)
    }
    
    @objc private func predictDigitButtonTapped() {
        delegate?.buttonTapped(buttonType: .predict)
    }
    
    @objc private func nextAndFinishButtonTapped() {
        delegate?.buttonTapped(buttonType: .nextAndFinish)
    }
}
