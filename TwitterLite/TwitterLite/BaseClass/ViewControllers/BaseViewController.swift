//
//  BaseViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import UIKit


class BaseViewController<T: BaseViewModel>: UIViewController {
    /* This is the actual height that fits the entire UI set up in the ViewCotnroller.
     * This height is used to calculate the scroll View's content height when Keyboard is dispalyed.
     */
    public var desiredHeight: CGFloat {
        return 0.0
    }

    public var isNetworkAvailable = false
    public var viewModel: T?
    public var activityView = ActivityIndicatorView(frame: .zero)

    private var networkStatusView: NetworkStatusView?
    private var isExpanded: Bool = false

    @IBOutlet weak public var theScrollView: UIScrollView?
    @IBOutlet weak private var scrollViewContentHeightConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        centerActivityView()

        if viewModel === .none {
            viewModel = T()
        }

        title = viewModel?.title

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
        theScrollView?.addGestureRecognizer(tapGesture)

        if desiredHeight > 0.0 {
            addObserver()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ReachabilityManager.shared.add(delegate: self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ReachabilityManager.shared.remove(delegate: self)
    }

    deinit {
        activityView.removeFromSuperview()

        if desiredHeight > 0.0 {
            removeObserver()
        }

        print("***** De-Init Called: \(self) *****")
    }

    // MARK: - Notification Methods -
    @objc
    public func tap(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc
    private func keyboardWillAppear(_ notification: Notification) {
        guard desiredHeight > 0.0 else {
            print("Please make sure to set 'desiredHeight' before using it.")

            return
        }

        var keyboardHeight: CGFloat = 0.0

        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }

        let totalHeight = desiredHeight + keyboardHeight

        if !isExpanded {
            theScrollView?.contentSize = CGSize(width: view.frame.width, height: totalHeight)
            scrollViewContentHeightConstraint?.constant = totalHeight

            isExpanded = true
        }
    }

    @objc
    private func keyboardWillDisappear(_ notification: Notification) {
        guard desiredHeight > 0.0 else {
            print("Please make sure to set 'desiredHeight' before using it.")

            return
        }

        if isExpanded {
            theScrollView?.contentSize = CGSize(width: view.frame.width, height: desiredHeight)
            scrollViewContentHeightConstraint?.constant = desiredHeight

            isExpanded = false
        }
    }

    // MARK - Public Methods -
    public func presentAlert(title: String = "Alert",
                             message: String,
                             alertAction: [UIAlertAction]) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        for action in alertAction {
            alert.addAction(action)
        }

        present(alert, animated: true)
    }

    public func networkStatusChanged(isNetworkAvailable: Bool) {
        self.isNetworkAvailable = isNetworkAvailable
        addRemoveNetworkView(isNetworkAvailable: isNetworkAvailable)
    }

    // MARK - Private Methods -
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: .none)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: .none)
    }

    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: .none)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisappear),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: .none)
    }

    private func centerActivityView() {
        view.addSubview(activityView)

        activityView.translatesAutoresizingMaskIntoConstraints = false

        let centerXAnchorConstraint = activityView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        let centerYAnchorConstraint = activityView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        let widthAnchorConstraint = activityView.widthAnchor.constraint(equalTo: view.widthAnchor)
        let heightAnchorConstraint = activityView.heightAnchor.constraint(equalTo: view.heightAnchor)

        view.addConstraints([centerXAnchorConstraint,
                             centerYAnchorConstraint,
                             widthAnchorConstraint,
                             heightAnchorConstraint])

        activityView.stopAnimating()
    }

    private func addRemoveNetworkView(isNetworkAvailable: Bool) {
        if isNetworkAvailable {
            networkStatusView?.removeFromSuperview()
            networkStatusView = .none
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

            print("Network Un-Reachable")
        case .wifi, .cellular:
            networkStatusChanged(isNetworkAvailable: true)

            print("Network Reachable")
        }
    }
}
