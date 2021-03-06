//
//  ErrorAlertView.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import UIKit

/// ErrorAlertView is an abstract alert for errors to show across the app.
///
/// Note:
/// for now we will use a quick one, but it can be enhance to build on more powerful abstractions
/// Example:
/// AbstractAlert(title, message, actions)
/// ErrorAlert: AbstractAlert(title, message, actions)
class ErrorAlertView {
    
    let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    func showOn(controller: UIViewController) {
        guard let error = error as? LocalizedError else {
            return
        }
        let alert = UIAlertController(
            title: error.errorDescription,
            message: error.failureReason,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Dismiss", style: .default, handler: nil))
        controller.present(alert, animated: true, completion: nil)
    }
    
}
