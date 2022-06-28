//
//  ReachabilityManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import Foundation
import Reachability


public protocol ConnectionStatusListener: AnyObject {
    func networkStatusDidChange(status: ConnectionStatus)
}


class ReachabilityManager {
    public static let shared = ReachabilityManager()
    public var connectionStatus: ConnectionStatus = .none

    private let reachability: Reachability!
    private var listeners = [ConnectionStatusListener]()

    // MARK: - Public Methods -
    public func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(reachabilityChanged),
                                               name: .reachabilityChanged,
                                               object: reachability)

        do {
            try reachability.startNotifier()
        } catch {
            startMonitoring()
            print("Could not start reachability notifier")
        }
    }

    public func stopMonitoring() {
        reachability.stopNotifier()

        NotificationCenter.default.removeObserver(self,
                                                  name: .reachabilityChanged,
                                                  object: reachability)
    }

    public func add(delegate listener: ConnectionStatusListener) {
        listeners.append(listener)
    }

    public func remove(delegate listener: ConnectionStatusListener) {
        listeners.removeAll { $0 === listener }
    }

    // MARK: - Private Methods -
    private init() {
        reachability = try! Reachability()
    }

    @objc
    private func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability

        switch reachability.connection {
        case .none:
            print("Network Unknown")
            connectionStatus = .none
        case .unavailable:
            print("Network became unreachable")
            connectionStatus = .unavailable
        case .wifi:
            print("Network reachable through WiFi")
            connectionStatus = .wifi
        case .cellular:
            print("Network reachable through Cellular Data")
            connectionStatus = .cellular
        }

        for listener in listeners {
            listener.networkStatusDidChange(status: connectionStatus)
        }
    }
}
