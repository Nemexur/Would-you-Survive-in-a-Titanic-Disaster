//
//  MainViewController.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

private extension CGFloat {
    static let scrollViewHeight: CGFloat = 140
    static let scrollViewWidth: CGFloat = 280
    static let scrollViewTopMargin: CGFloat = 8
    
    static let regularTitleLabelTopMargin: CGFloat = UIDevice.safeAreaInsets.top + 30
    static let compactTitleLabelTopMargin: CGFloat = 20
    static let titleLabelSideMargin: CGFloat = -8
    
    static let baseBorderWidth: CGFloat = 2
    
    static let buttonsStackWidth: CGFloat = 190
    static let buttonsStackMargin: CGFloat = 8
    
    static let alertViewDefaultBottomAnchor: CGFloat = -100
    static let alertViewCornerRadius: CGFloat = 40
    static let alertViewWidth: CGFloat = 250
    static let alertViewHeight: CGFloat = 200
    
    static let canvasViewWidth: CGFloat = 270
    static let compactCanvasViewTopMargin: CGFloat = 8
}

private extension UIColor {
    static let scrollViewBorderColor = UIColor(hex: 0xff512f).withAlphaComponent(0.5)
}

private extension CGSize {
    static let predictionDigitSize = CGSize(width: 28, height: 28)
}

final public class MainViewController: UIViewController {
    
    // Dependencies
    private lazy var presenter: IMainPresenter = {
        let presenter = MainPresenter()
        presenter.view = self
        return presenter
    }()
    
    // Constraints
    private var sharedConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []
    private var compactConstraints: [NSLayoutConstraint] = []
    
    // UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = loc("title_text")
        label.font = UIFont(name: loc("basic_font"), size: 30)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.delegate = self
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.layer.borderColor = UIColor.scrollViewBorderColor.cgColor
        scroll.layer.borderWidth = .baseBorderWidth
        scroll.layer.cornerRadius = .scrollViewHeight / 5
        return scroll
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = presenter.viewModels.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.tintColor = .white
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private lazy var canvasView: CanvasView = {
        let canvasView = CanvasView()
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        canvasView.layer.borderColor = UIColor.whiteAlpha50.cgColor
        canvasView.layer.borderWidth = 2
        canvasView.contentMode = .scaleAspectFit
        return canvasView
    }()
    
    private lazy var buttonsStack: ButtonsStack = {
        let buttonsStack = ButtonsStack()
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.delegate = self
        return buttonsStack
    }()
    
    private lazy var alertView: AlertView = {
        let alertView = AlertView(in: view)
        alertView.backgroundColor = .gray
        alertView.layer.borderColor = UIColor.lightGray.cgColor
        alertView.layer.borderWidth = .baseBorderWidth
        alertView.layer.cornerRadius = .alertViewCornerRadius
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()
    
    private lazy var alertBackgroundView: UIView = {
        let alertBackgroundView = createEmptyView()
        alertBackgroundView.alpha = 0
        alertBackgroundView.backgroundColor = .blackAlpha30
        return alertBackgroundView
    }()
    
    // Models
    private var userInput: [InputViewType: (value: Double, regexp: String)] = [:]
    
    // MARK: - Override
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Configure UI
    
    private func setupUI() {
        view.setGradient(with: Gradients.mainViewGradient, direction: .fromLeftBottom)
        configureTitleLabel()
        configureScrollView()
        configurePageControl()
        configureCanvasView()
        configureButtonsStack()
        configureAlertBackgroundView()
        configureAlertView()
    }
    
    private func configureTitleLabel() {
        view.addSubview(titleLabel)
        sharedConstraints.append(contentsOf: [
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: .titleLabelSideMargin),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -.titleLabelSideMargin)
        ])
        regularConstraints.append(contentsOf: [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: .regularTitleLabelTopMargin)
        ])
        compactConstraints.append(contentsOf: [
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: .compactTitleLabelTopMargin)
        ])
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        sharedConstraints.append(contentsOf: [
            scrollView.widthAnchor.constraint(equalToConstant: .scrollViewWidth),
            scrollView.heightAnchor.constraint(equalToConstant: .scrollViewHeight),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .scrollViewTopMargin)
        ])
        regularConstraints.append(contentsOf: [
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        compactConstraints.append(contentsOf: [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: UIDevice.safeAreaInsets.left + view.bounds.width / 6),
        ])
        scrollView.contentSize = CGSize(width: .scrollViewWidth * CGFloat(presenter.viewModels.count),
                                         height: .scrollViewHeight)
        for i in 0..<presenter.viewModels.count {
            let shadowView = InputViewWithTextField()
            shadowView.configure(with: presenter.viewModels[i])
            shadowView.frame = CGRect(x: .scrollViewWidth * CGFloat(i), y: 0, width: .scrollViewWidth, height: .scrollViewHeight)
            scrollView.addSubview(shadowView)
        }
    }
    
    private func configurePageControl() {
        view.addSubview(pageControl)
        sharedConstraints.append(contentsOf: [
            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureCanvasView() {
        view.addSubview(canvasView)
        regularConstraints.append(contentsOf: [
            canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
            canvasView.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            canvasView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
        compactConstraints.append(contentsOf: [
            canvasView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .compactCanvasViewTopMargin),
            canvasView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(UIDevice.safeAreaInsets.left + view.bounds.width / 6)),
            canvasView.widthAnchor.constraint(equalToConstant: 250),
            canvasView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    private func configureButtonsStack() {
        view.addSubview(buttonsStack)
        sharedConstraints.append(contentsOf: [
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.widthAnchor.constraint(equalToConstant: .buttonsStackWidth)
        ])
        regularConstraints.append(contentsOf: [
            buttonsStack.topAnchor.constraint(equalTo: canvasView.bottomAnchor, constant: .buttonsStackMargin)
        ])
        compactConstraints.append(contentsOf: [
            buttonsStack.topAnchor.constraint(equalTo: pageControl.bottomAnchor)
        ])
    }
    
    private func configureAlertBackgroundView() {
        view.addSubview(alertBackgroundView)
        alertBackgroundView.autoPinEdgesToSuperView(view)
    }
    
    private func configureAlertView() {
        view.addSubview(alertView)
        alertView.backgroundView = alertBackgroundView
        sharedConstraints.append(contentsOf: [
            alertView.widthAnchor.constraint(equalToConstant: .alertViewWidth),
            alertView.heightAnchor.constraint(equalToConstant: .alertViewHeight),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: .alertViewDefaultBottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    private func showAlertView(with error: String) {
        alertView.present(text: error, type: .error)
    }
    
    private func showAlertView(with prediction: Survived?) {
        guard let prediction = prediction else {
            alertView.present(text: loc("wrong_data_message"), type: .error)
            return
        }
        switch prediction {
        case .died:
            alertView.present(text: loc("passenger_died_message"), type: .message)
        case .survived:
            alertView.present(text: loc("passenger_survived_message"), type: .message)
        }
    }
    
    private func processNextAndFinishTap() {
        switch buttonsStack.nextAndFinishButton.buttonState {
        case .next:
            goToNextPage()
        case .finish:
            predictFortune()
        }
    }
    
    private func goToNextPage() {
        pageControl.currentPage = pageControl.currentPage + 1
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        updateNextAndFinishButtonIfNeeded()
    }
    
    private func updateNextAndFinishButtonIfNeeded() {
        if pageControl.currentPage == presenter.viewModels.count - 1 {
            buttonsStack.nextAndFinishButton.buttonState = .finish
        } else {
            buttonsStack.nextAndFinishButton.buttonState = .next
        }
    }
    
    private func setInitialState() {
        cleanCanvas()
        clearTextFields()
        goToFirstPage()
        cleanCashedUserInputData()
    }
    
    private func cleanCanvas() {
        if canvasView.state == .cleaned {
            (scrollView.subviews[pageControl.currentPage] as? InputViewWithTextField)?.cleanTextField()
        } else {
            canvasView.state = .cleaned
            canvasView.image = nil
        }
    }
    
    private func clearTextFields() {
        scrollView.subviews.forEach { ($0 as? InputViewWithTextField)?.cleanTextField() }
    }
    
    private func goToFirstPage() {
        pageControl.currentPage = 0
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
        updateNextAndFinishButtonIfNeeded()
    }
    
    private func cleanCashedUserInputData() {
        userInput = [:]
    }
    
    private func predictFortune() {
        obtainUserInputData()
        guard presenter.validate(data: userInput) else { cleanCashedUserInputData(); return }
        presenter.predict(data: UserInputViewModel.from(userInput)) { [weak self] result in
            guard let self = self else { return }
            self.showAlertView(with: result)
            self.setInitialState()
        }
    }
    
    private func predictHandWrittenDigit() {
        guard let imageData = canvasView.image?.processImageForPrediction(with: .predictionDigitSize) else { return }
        presenter.predictDigit(with: imageData) { [weak self] prediction in
            guard let strongSelf = self,
                let prediction = prediction else { self?.showAlertView(with: loc("wrong_data_message")); return }
            (strongSelf.scrollView.subviews[strongSelf.pageControl.currentPage] as? InputViewWithTextField)?.updateTextField(with: prediction)
            strongSelf.cleanCanvas()
        }
    }
    
    private func obtainUserInputData() {
        for i in 0..<pageControl.numberOfPages {
            if let data = scrollView.subviews[i] as? InputViewWithTextField {
                userInput[data.type] = data.getTextFieldInputAndRegex()
            }
        }
    }
    
}

// MARK: - StatusBar

extension MainViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - IMainView

extension MainViewController: IMainView {
    func showError(text: String) {
        alertView.present(text: text, type: .error)
    }
}

// MARK: - UIScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageIndex)
        updateNextAndFinishButtonIfNeeded()
    }
}

// MARK: - ButtonsStackDelegate

extension MainViewController: ButtonsStackDelegate {
    func buttonTapped(buttonType: ButtonsStack.ButtonsStackType) {
        switch buttonType {
        case .clear:
            cleanCanvas()
        case .predict:
            predictHandWrittenDigit()
        case .nextAndFinish:
            processNextAndFinishTap()
        }
    }
}

// MARK: - Orientation changes

extension MainViewController {
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if sharedConstraints.first?.isActive == false {
            NSLayoutConstraint.activate(sharedConstraints)
        }
        if (traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular) || (traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular) {
            if !compactConstraints.isEmpty && compactConstraints.first?.isActive == true {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            NSLayoutConstraint.activate(regularConstraints)
        } else {
            if !regularConstraints.isEmpty && regularConstraints.first?.isActive == true {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            NSLayoutConstraint.activate(compactConstraints)
        }
    }
}
