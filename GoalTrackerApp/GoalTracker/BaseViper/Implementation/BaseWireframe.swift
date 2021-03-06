//
//  BaseWireframe.swift
//  Classifieds
//
//  Created by Georges on 2/19/21.
//

import UIKit

/// Exposes common wireframe functionality and helpers to push/present and pop other wireframes
class BaseWireframe {
    private unowned var _viewController: UIViewController
    
    // this is to retain view controller reference upon first access
    // this is required to prevent automatic deallocation on init(:)
    private var _temporaryStoredViewController: UIViewController?
    
    /// Initialize the wireframe with a view controller
    init(viewController: UIViewController) {
        _temporaryStoredViewController = viewController
        _viewController = viewController
    }
}

extension BaseWireframe: WireframeInterface {
    /// The wireframe's internal ViewController
    var viewController: UIViewController {
        defer { _temporaryStoredViewController = nil }
        return _viewController
    }
    /// The wireframe's internal ViewController's navigation controller
    var navigationController: UINavigationController? {
        return viewController.navigationController
    }
}
