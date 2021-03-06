//
//  ViewController.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import UIKit
import UserGoalsService
import ApiCall
import Combine

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPermission()
    }
    
    // Note: this is a quick one for now
    func checkPermission() {
        HealthKitPermissions().requestPermission { (status) in
            DispatchQueue.main.async {
                switch status {
                case .authorized:
                    self.showApp()
                default:
                    let alert = UIAlertController(title: "Please enable access to health via settings", message: nil, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func showApp() {
        let wireframe = MyGoalsScreenWireframe()
        let view = wireframe.viewController
        let nav = UINavigationController(rootViewController: view)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
}

