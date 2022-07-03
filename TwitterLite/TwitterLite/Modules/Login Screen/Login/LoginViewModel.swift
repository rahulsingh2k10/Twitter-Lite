//
//  LoginViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import UIKit


class LoginViewModel: BaseViewModel {
    // MARK: - Public Methods -
    public func signInToGoogle(viewController: UIViewController,
                               didStartAuthCallback: @escaping CallBack,
                               callBackHandler: @escaping UserCallBack) {
        GoogleSignInManager.shared.siginInWithGoogle(viewController: viewController,
                                                     didStartAuthCallback: didStartAuthCallback,
                                                     callBackHandler: callBackHandler)
    }
}
