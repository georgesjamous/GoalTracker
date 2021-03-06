//
//  UIViewController+ErrorHandler.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit

extension UIViewController {
    func handleError(error: Error) {
        ErrorAlertView(error: error).showOn(controller: self)
    }
}

// so that we can use it with viper
extension ViewInterface {
    func handleError(error: Error) {
        if let v = self as? UIViewController {
            ErrorAlertView(error: error).showOn(controller: v)
        }
    }
}

