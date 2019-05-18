//
//  Localization.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 01/04/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation

typealias LocalizedString = String

func loc(_ string: String) -> LocalizedString {
    let bundleIdentifier = "com.nemexur.CoreMLExample"
    guard let bundle = Bundle(identifier: bundleIdentifier) else {
        fatalError("Не найден bundle по идентификатору \(bundleIdentifier)")
    }
    return NSLocalizedString(string, bundle: bundle, comment: "")
}
