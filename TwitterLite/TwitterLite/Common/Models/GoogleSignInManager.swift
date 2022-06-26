//
//  GoogleSignInManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 25/06/22.
//

import Foundation
import GoogleSignIn


struct GoogleSignInManager {
    static var shared: GoogleSignInManager = GoogleSignInManager()

    private init() {}

    // MARK: - Public Methods -
    public func siginInWithGoogle(viewController: UIViewController,
                                  callBackHandler: @escaping SignInCallBack) {
        guard let clientID = FirebaseManager.shared.getClientID() else {
            callBackHandler(.none, LoginError.missingClientID)

            return
        }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { user, error in
            if let error = error {
                callBackHandler(.none, error)
            } else if let user = user {
                let authentication = user.authentication

                guard let idToken = authentication.idToken else {
                    callBackHandler(.none, LoginError.invalidTokenID)

                    return
                }

                FirebaseManager.shared.authenticateUser(withIDToken: idToken,
                                                        accessToken: authentication.accessToken,
                                                        callBackHandler: callBackHandler)
            }
        }
    }
}
