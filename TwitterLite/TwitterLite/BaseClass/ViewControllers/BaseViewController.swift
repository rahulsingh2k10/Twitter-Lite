//
//  BaseViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import UIKit


class BaseViewController<T: BaseViewModel>: UIViewController {
    public var isNetworkAvailable = false
    public var viewModel: T?

    private var networkStatusView: NetworkStatusView?

    override func viewDidLoad() {
        super.viewDidLoad()

        ReachabilityManager.shared.add(delegate: self)

        if viewModel === .none {
            viewModel = T()
        }

        title = viewModel?.title
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.edgesForExtendedLayout = []
    }

    deinit {
        ReachabilityManager.shared.remove(delegate: self)
    }

    // MARK - Public Methods -
    public func networkStatusChanged(isNetworkAvailable: Bool) {
        self.isNetworkAvailable = isNetworkAvailable
        addRemoveNetworkView(isNetworkAvailable: isNetworkAvailable)

        if isNetworkAvailable == true {
            print("Network Reachable")
        } else {
            print("Network Un-Reachable")
        }
    }

    // MARK - Private Methods -
    private func addRemoveNetworkView(isNetworkAvailable: Bool) {
        if isNetworkAvailable {
            if networkStatusView != .none {
                networkStatusView?.removeFromSuperview()
                networkStatusView = nil
            }
        } else {
            networkStatusView = NetworkStatusView(frame: .zero)
            view.addSubview(networkStatusView!)

            networkStatusView?.translatesAutoresizingMaskIntoConstraints = false
            let leadingAnchorConstraint = networkStatusView!.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            let trailingAnchorConstraint = networkStatusView!.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            let bottomAnchorConstraint = networkStatusView!.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

            view.addConstraints([leadingAnchorConstraint, trailingAnchorConstraint, bottomAnchorConstraint])
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
