//
//  UIView+Round.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func makeShadow() {
        layer.shadowRadius = 3.0
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 1.0
    }
    
    func setGradient(with colors: [UIColor], direction: GradientView.Direction) {
        let gradient = GradientView()
        gradient.gradientColors = colors
        gradient.direction = direction
        addSubview(gradient)
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.autoPinEdgesToSuperView(self)
    }
    
    func makeSimpleConstraintsAndRound(with constant: CGFloat) {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        layer.cornerRadius = constant / 2
        clipsToBounds = true
    }
    
    func autoPinEdgesToSuperView(_ view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - UIView Helpers

func createEmptyView() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}

func createEmptySeparatorView() -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: 2).isActive = true
    view.backgroundColor = .lightGray
    return view
}

func createEmptyView(height: CGFloat) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: height).isActive = true
    return view
}

func createEmptyView(width: CGFloat) -> UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.widthAnchor.constraint(equalToConstant: width).isActive = true
    return view
}
