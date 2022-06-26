//
//  FirebaseManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation
import FirebaseCore
import FirebaseAuth


struct FirebaseManager {
    static var shared: FirebaseManager = FirebaseManager()
    private init() {}

    // MARK: - Public Methods -
    public func getClientID() -> String? {
        return FirebaseApp.app()?.options.clientID
    }

    public func authenticateUser(withIDToken idToken: String,
                                 accessToken: String,
                                 callBackHandler: @escaping SignInCallBack) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)

        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                callBackHandler(.none, error)
            } else if let authResult = authResult {
                let user = authResult.user
                let loggedInUser = LoggedInUserModel(userName: user.email,
                                                     displayName: user.displayName,
                                                     photoURL: user.photoURL as URL?,
                                                     phoneNumber: user.phoneNumber)

                callBackHandler(loggedInUser, .none)
            }
        }
    }
}
