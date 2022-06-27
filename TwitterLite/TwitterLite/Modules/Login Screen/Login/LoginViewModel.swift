//
//  LoginViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation
import UIKit


class LoginViewModel: BaseViewModel {
    //MARK: - Public Methods - 
    public func signInToGoogle(viewController: UIViewController,
                               didStartAuthCallback: @escaping CallBack,
                               callBackHandler: @escaping SignInCallBack) {
        GoogleSignInManager.shared.siginInWithGoogle(viewController: viewController,
                                                     didStartAuthCallback: didStartAuthCallback,
                                                     callBackHandler: callBackHandler)
    }
}
