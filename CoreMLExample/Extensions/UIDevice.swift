//
//  UIDevice.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 01/04/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

private let device = Device()

extension UIDevice {
    static var isIphoneX: Bool {
        if  device == .iPhoneX                 ||
            device == .iPhoneXr                ||
            device == .iPhoneXs                ||
            device == .iPhoneXsMax             ||
            device == .simulator(.iPhoneX)     ||
            device == .simulator(.iPhoneXr)    ||
            device == .simulator(.iPhoneXs)    ||
            device == .simulator(.iPhoneXsMax) {
            return true
        } else {
            return false
        }
    }
    
    static var safeAreaInsets: UIEdgeInsets {
        if isIphoneX {
            return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        } else {
            return .zero
        }
    }
}
