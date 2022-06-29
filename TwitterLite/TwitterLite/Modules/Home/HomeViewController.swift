//
//  HomeViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import UIKit


class HomeViewController: BaseViewController<BaseViewModel> {
    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var newTweetButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        newTweetButton.isHidden = true

        activityView.startAnimating()
        if FirebaseManager.shared.currentUser() == .none {
            activityView.stopAnimating()

            openLoginViewController()
        } else {
            fetchUserDetails()
        }
    }

    // MARK: - Action Methods -
    @IBAction private func signOutButtonClicked(_ sender: Any) {
        let yesAction = UIAlertAction(title: StringValue.yesTitle.rawValue,
                                      style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.activityView.startAnimating(title: StringValue.signingOut.rawValue)

            FirebaseManager.shared.signOut() { [weak self] error in
                guard let strongSelf = self else { return }

                strongSelf.activityView.stopAnimating()

                strongSelf.openLoginViewController(true)
            }
        }

        let cancelAction = UIAlertAction(title: StringValue.cancelTitle.rawValue,
                                         style: .default,
                                         handler: .none)

        presentAlert(message: StringValue.signOutConfirmation.rawValue,
                     alertAction: [yesAction, cancelAction])
    }

    // MARK: - Private Methods -
    private func fetchUserDetails() {
        FirebaseDatabaseManager.shared.fetchUserDetails() { [weak self] error in
            guard let strongSelf = self else { return }

            strongSelf.activityView.stopAnimating()
            strongSelf.profileView.loadImage(url: Utils.shared.loggedInUser?.photoURL)
            strongSelf.newTweetButton.isHidden = false
        }
    }

    private func openLoginViewController(_ animated: Bool = false) {
        DispatchQueue.main.async() {[weak self] in
            guard let strongSelf = self else { return }

            let loginVC = UIStoryboard(name: .Login).viewController(type: LoginViewController.self) as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.loginDelegate = self

            strongSelf.present(loginVC, animated: animated)
        }
    }
}

extension HomeViewController: LoginDelegate {
    func loginDidComplete() {
        activityView.startAnimating()

        fetchUserDetails()
    }
}
