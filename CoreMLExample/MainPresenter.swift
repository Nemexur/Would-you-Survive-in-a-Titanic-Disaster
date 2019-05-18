//
//  MainPresenter.swift
//  CoreMLExample
//
//  Created by Alex Milogradsky on 21/03/2019.
//  Copyright © 2019 Alex Milogradsky. All rights reserved.
//

import Foundation
import UIKit
import CoreML

// I've got this values from analyzing the Titanic Dataset
private extension Double {
    static let ageMean = 29.699117647058763
    static let ageStd = 13.002015226002884
}

enum Survived: String {
    case survived = "1"
    case died = "0"
}

struct UserInputViewModel {
    let pclass: Double
    let sex: Double
    let age: Double
    let embarked: Double
    let alliance: Double
    
    static func from(_ data: [InputViewType: (value: Double, regexp: String)]) -> UserInputViewModel {
        return UserInputViewModel(pclass: data[.pclass]?.value ?? 0,
                                  sex: data[.sex]?.value ?? 0,
                                  age: data[.age]?.value ?? 0,
                                  embarked: data[.embarked]?.value ?? 0,
                                  alliance: data[.alliance]?.value ?? 0)
    }
}

protocol IMainPresenter {
    var viewModels: [InputViewModel] { get }
    func predict(data: UserInputViewModel, completion: @escaping ((Survived?) -> Void))
    func predictDigit(with imageData: CVPixelBuffer, completion: @escaping ((String?) -> Void))
    func validate(data: [InputViewType: (value: Double, regexp: String)]) -> Bool
}

protocol IMainView: class {
    func showError(text: String)
}

final class MainPresenter: IMainPresenter {
    
    // Dependencies
    weak var view: IMainView?
    
    // ViewModel
    var viewModels: [InputViewModel] {
        return [
            InputViewModel(hint: loc("pclass_hint"), placeholder: loc("pclass_placeholder"), validationRegexp: loc("pclass_regexp"), type: .pclass),
            InputViewModel(hint: loc("sex_hint"), placeholder: loc("sex_placeholder"), validationRegexp: loc("sex_regexp"), type: .sex),
            InputViewModel(hint: loc("age_hint"), placeholder: loc("age_placeholder"), validationRegexp: loc("age_regexp"), type: .age),
            InputViewModel(hint: loc("embarked_hint"), placeholder: loc("embarked_placeholder"), validationRegexp: loc("embarked_regexp"), type: .embarked),
            InputViewModel(hint: loc("alliance_hint"), placeholder: loc("alliance_placeholder"), validationRegexp: loc("alliance_regexp"), type: .alliance),
        ]
    }
    
    // MARK: - IMainPresenter
    
    func predict(data: UserInputViewModel, completion: @escaping ((Survived?) -> Void)) {
        guard let result = try? TitanicFortune().prediction(Pclass: data.pclass, Sex: data.sex, Age: scaleAge(data.age), Embarked: data.embarked, Alliance: data.alliance)
            else { completion(nil); return }
        completion(Survived(rawValue: String(result.Survived)))
    }
    
    func predictDigit(with imageData: CVPixelBuffer, completion: @escaping ((String?) -> Void)) {
        guard let result = try? MNISTClassifier().prediction(image: imageData) else { return completion(nil) }
        completion(result.classLabel)
    }
    
    func validate(data: [InputViewType: (value: Double, regexp: String)]) -> Bool {
        let count = data.count
        if count != viewModels.count {
            view?.showError(text: loc("input_field_error_message"))
            return false
        } else {
            var result = true
            for i in 0..<count {
                guard let inputType = InputViewType(rawValue: i) else { view?.showError(text: loc("validation_error_message")); return false }
                if !checkInput(input: data[inputType]?.value, regexp: data[inputType]?.regexp) {
                    result = false
                }
            }
            guard result else { view?.showError(text: loc("validation_error_message")); return result }
            return result
        }
    }
    
    // MARK: - Private
    
    private func scaleAge(_ age: Double) -> Double {
        return (age - .ageMean) / .ageStd
    }
    
    private func checkInput(input: Double?, regexp: String?) -> Bool {
        guard let input = input,
            let regexp = regexp else { return false }
        let string = String(Int(input))
        guard let regex = try? NSRegularExpression(pattern: regexp, options: [.caseInsensitive]) else { return false }
        return regex.numberOfMatches(in: string, options: [], range: NSMakeRange(0, string.count)) > 0
    }
}
