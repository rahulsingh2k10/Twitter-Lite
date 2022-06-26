//
//  ViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 23/06/22.
//

import UIKit
import GoogleSignIn


class ViewController: BaseViewController<BaseViewModel> {
    @IBOutlet weak var googleSignInView: GIDSignInButton!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        googleSignInView.style = .wide
    }

    @IBAction func googleSignInViewClicked(_ sender: Any) {
        GoogleSignInManager.shared.siginInWithGoogle(viewController: self) {user, error in
            
        }
    }
}
