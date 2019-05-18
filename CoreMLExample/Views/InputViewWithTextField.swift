//
//  InputViewWithTextField.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

struct InputViewModel {
    let hint: String
    let placeholder: String
    let validationRegexp: String
    let type: InputViewType
}

private enum Constants {
    static let baseOffset: CGFloat = 8
    static let baseFontSize: CGFloat = 16
    static let textFieldHeight: CGFloat = 40
    static let middleSeparator: CGFloat = 10
    static let bottomSeparator: CGFloat = 10
    static let stackViewMargin = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    static let huggingPriority: Float = 200
    static let compressionResistancePriority: Float = 500
}

enum InputViewType: Int {
    case pclass = 0
    case sex = 1
    case age = 2
    case embarked = 3
    case alliance = 4
}

final class InputViewWithTextField: UIView {
    
    // UI
    private lazy var topEmptyView: UIView = {
        let view = createEmptyView()
        view.setContentHuggingPriority(UILayoutPriority(rawValue: Constants.huggingPriority), for: .vertical)
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: Constants.compressionResistancePriority), for: .vertical)
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 20
        textField.makeShadow()
        textField.textColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var hintLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: loc("basic_font"), size: Constants.baseFontSize)
        label.textColor = .whiteAlpha80
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackViewContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Constants.stackViewMargin
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // Models
    private var validationRegexp = String()
    var type: InputViewType = .pclass
    
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
        configureStackView()
        setupTextFieldPadding()
    }
    
    private func configureStackView() {
        addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(topEmptyView)
        stackViewContainer.addArrangedSubview(hintLabel)
        stackViewContainer.addArrangedSubview(createEmptyView(height: Constants.middleSeparator))
        stackViewContainer.addArrangedSubview(textField)
        stackViewContainer.addArrangedSubview(createEmptyView(height: Constants.bottomSeparator))
        stackViewContainer.autoPinEdgesToSuperView(self)
        textField.heightAnchor.constraint(equalToConstant: Constants.textFieldHeight).isActive = true
    }
    
    private func setupTextFieldPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    func configure(with model: InputViewModel) {
        let attributedPlaceholder = NSAttributedString(string: model.placeholder,
                                                       attributes: [
                                                        .font: UIFont(name: loc("basic_font"), size: Constants.baseFontSize) ?? .forSize(13),
                                                        .foregroundColor: UIColor.whiteAlpha50])
        textField.attributedPlaceholder = attributedPlaceholder
        hintLabel.text = model.hint
        validationRegexp = model.validationRegexp
        type = model.type
    }
    
    // MARK: - Actions
    
    func getTextFieldInputAndRegex() -> (Double, String)? {
        guard let text = textField.text,
            let textToDouble = Double(text) else { return nil }
        return (textToDouble, validationRegexp)
    }
    
    func getTextFieldInput() -> Double? {
        guard let input = textField.text else { return nil }
        return Double(input)
    }
    
    func updateTextField(with string: String) {
        guard let text = textField.text else { textField.text = string; return }
        textField.text = text + string
    }
    
    func cleanTextField() {
        textField.text = nil
    }
}
