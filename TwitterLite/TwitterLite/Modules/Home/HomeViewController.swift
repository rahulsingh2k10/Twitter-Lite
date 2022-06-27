//
//  HomeViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import UIKit


class HomeViewController: BaseViewController<BaseViewModel> {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        GoogleSignInManager.shared.restoreuser { [weak self] (user, error) in
            guard let strongSelf = self else { return }

            if let error = error, (error as NSError).code != -4 {
                strongSelf.presentAlert(message: error.localizedDescription, alertAction: [])
            } else if let user = user {
                Utils.shared.loggedInUser = user
            } else {
                let loginVC = UIStoryboard(name: .Login).viewController(type: LoginViewController.self) as! LoginViewController
                loginVC.modalPresentationStyle = .fullScreen

                strongSelf.present(loginVC, animated: false)
            }
        }
    }
}
