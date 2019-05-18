//
//  AlertView.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 22/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private enum Constants {
    static let baseFontSize: CGFloat = 24
    static let buttonsHeight: CGFloat = 50
    static let separatorHeight: CGFloat = 8
    static let huggingPriority: Float = 200
    static let compressionResistancePriority: Float = 500
    static let textLabelMargin: CGFloat = 8
}

private extension UIColor {
    static let errorMessageColor: UIColor = .blackAlpha80
}

final class AlertView: UIView {
    
    enum AlertViewType {
        case error
        case message
        
        var color: UIColor {
            switch self {
            case .error:
                return .errorMessageColor
            case .message:
                return .whiteAlpha80
            }
        }
    }
    
    // Dependencies
    weak var backgroundView: UIView?
    
    // UI
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: loc("basic_font"), size: Constants.baseFontSize)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: Constants.huggingPriority), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: Constants.compressionResistancePriority), for: .vertical)
        return label
    }()
    
    private lazy var okButton: NextAndFinishButton = {
        let button = NextAndFinishButton(gradientColors: Gradients.nexAndFinishGradient)
        button.buttonState = .finish
        return button
    }()
    
    private lazy var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    // Properties
    private let view: UIView
    
    // MARK: - Init
    
    init(in view: UIView, frame: CGRect = .zero) {
        self.view = view
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure UI
    
    private func setupUI() {
        setupGestures()
        configureStackView()
        configureStackViewSubviews()
    }
    
    private func configureStackView() {
        addSubview(stackViewContainer)
        okButton.makeSimpleConstraintsAndRound(with: Constants.buttonsHeight)
        stackViewContainer.autoPinEdgesToSuperView(self)
    }
    
    private func configureStackViewSubviews() {
        let emptyView = createEmptyView(height: Constants.buttonsHeight)
        let emptyViewForTextLabel = createEmptyView()
        stackViewContainer.addArrangedSubview(emptyViewForTextLabel)
        stackViewContainer.addArrangedSubview(createEmptySeparatorView())
        stackViewContainer.addArrangedSubview(createEmptyView(height: Constants.separatorHeight))
        stackViewContainer.addArrangedSubview(emptyView)
        stackViewContainer.addArrangedSubview(createEmptyView(height: Constants.separatorHeight))
        
        emptyView.addSubview(okButton)
        okButton.makeSimpleConstraintsAndRound(with: Constants.buttonsHeight)
        okButton.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        okButton.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        
        emptyViewForTextLabel.topAnchor.constraint(equalTo: stackViewContainer.topAnchor).isActive = true
        emptyViewForTextLabel.addSubview(textLabel)
        textLabel.topAnchor.constraint(equalTo: emptyViewForTextLabel.topAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: emptyViewForTextLabel.bottomAnchor).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: emptyViewForTextLabel.leadingAnchor, constant: Constants.textLabelMargin).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: emptyViewForTextLabel.trailingAnchor, constant: -Constants.textLabelMargin).isActive = true
    }
    
    // MARK: - Gestures
    
    private func setupGestures() {
        let okButtonTap = UITapGestureRecognizer(target: self, action: #selector(okButtonDidTapped))
        okButton.addGestureRecognizer(okButtonTap)
    }
    
    @objc private func okButtonDidTapped() {
        dismiss()
    }
    
    // MARK: - Animation
    
    func present(text: String, type: AlertViewType) {
        textLabel.textColor = type.color
        textLabel.text = text
        UIView.animate(withDuration: .animation600ms,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.2,
                       options: [.curveEaseInOut],
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height / 2 + 100)
                        self.backgroundView?.alpha = 1
                        self.alpha = 1 },
                       completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: .animation400ms,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.alpha = 0
                        self.backgroundView?.alpha = 0
                        self.layoutIfNeeded() }) { [weak self] _ in
                            guard let self = self else { return }
                            self.setToInitialState()
                            
        }
    }
    
    private func setToInitialState() {
        UIView.animate(withDuration: .animation0ms,
                       delay: 0,
                       options: [.curveEaseOut],
                       animations: { [weak self] in
                        guard let self = self else { return }
                        self.transform = CGAffineTransform.identity
                        self.backgroundView?.alpha = 0 },
                       completion: nil)
    }
}
