//
//  BaseViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import UIKit


class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        ReachabilityManager.shared.add(delegate: self)
    }

    deinit {
        ReachabilityManager.shared.remove(delegate: self)
    }

    public func networkStatusChanged(isNetworkAvailable: Bool) {
        if isNetworkAvailable == true {
            print("Network Reachable")
        } else {
            print("Network Un-Reachable")
        }
    }
}


extension BaseViewController: ConnectionStatusListener {
    func networkStatusDidChange(status: ConnectionStatus) {
        switch status {
        case .none, .unavailable:
            networkStatusChanged(isNetworkAvailable: false)
        case .wifi, .cellular:
            networkStatusChanged(isNetworkAvailable: true)
        }
    }
}
