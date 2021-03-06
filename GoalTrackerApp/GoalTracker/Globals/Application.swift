//
//  Application.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Swinject

/// Application context is a global _Context_ that
/// contains high level system services that are not related to the user.
///
/// It is not used to replace dependency injection, but to
/// set system level configuration and globally used services.
class Application {
    
    static let shared: Application = Application()
    static var container: Container { Application.shared.container }
    
    private init() { setupDI() }
    
    /// Shared dependency container.
    /// Note: For now that is okay.
    let container = Container()
    /// Current device
    let device = Device()
    /// Current Date resolver
    var now: Date { World.date }
    /// Current calendar resolver
    var calendar: Calendar { World.calendar }
    
}
