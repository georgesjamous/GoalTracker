//
//  Device.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import Foundation
import Network

/// The current device level systems
///
/// Network State || Thermal State || Storage State
///
/// Note:
/// This can be split to multiple subsystems for ex: "NetworkMonitoring", "ThermalMonitoring"
/// we cam use this to control refresh rate from external health providers or image queality loading.
class Device {
    
    private let monitor = NWPathMonitor()
    
    public init() {
        startMonitoringNetwork()
    }
    
    private func startMonitoringNetwork() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isNetworkConstrained = path.isConstrained || path.isExpensive
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    /// Retruns `true` if the device's network is considered expensive.
    public var isNetworkConstrained: Bool = false
    
}
