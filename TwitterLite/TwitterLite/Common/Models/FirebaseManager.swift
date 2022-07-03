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

    private init() {
        FirebaseApp.configure()
    }

    // MARK: - Public Methods -
    public func signOut(callBack: CallBack) {
        do {
            try Auth.auth().signOut()

            callBack(.none)
        } catch {
            callBack(error)
        }
    }

    public func currentUser() -> User? {
        return Auth.auth().currentUser
    }

    public func getClientID() -> String? {
        return FirebaseApp.app()?.options.clientID
    }

    public func signin(userDetail: UserModel, callBackHandler: @escaping UserCallBack) {
        guard let emailAddress = userDetail.emailAddress,
              let password = userDetail.password else {
            callBackHandler(.none, LoginError.missingParameters)

            return
        }

        Auth.auth().signIn(withEmail: emailAddress,
                           password: password) { authResult, error in
            authenticationDidComplete(authResult: authResult, error: error, callBackHandler: callBackHandler)
        }
    }

    public func authenticateUser(withIDToken idToken: String,
                                 accessToken: String,
                                 callBackHandler: @escaping UserCallBack) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)

        Auth.auth().signIn(with: credential) { authResult, error in
            authenticationDidComplete(authResult: authResult, error: error, callBackHandler: callBackHandler)
        }
    }

    public func createAccount(userDetail: UserModel, callBackHandler: @escaping UserCallBack) {
        guard let emailAddress = userDetail.emailAddress,
              let password = userDetail.password else {
            callBackHandler(.none, LoginError.missingParameters)

            return
        }

        Auth.auth().createUser(withEmail: emailAddress, password: password) { authResult, error in
            if let error = error {
                callBackHandler(.none, error)
            } else if let authResult = authResult {
                let user = authResult.user
                var loggedInUser = userDetail
                loggedInUser.userID = user.uid

                update(user: loggedInUser, callBackHandler: callBackHandler)
            }
        }
    }

    // MARK: - Private Methods -
    private func update(user: UserModel, callBackHandler: @escaping UserCallBack) {
        FirebaseDatabaseManager.shared.updateUser(user: user) { error in
            if let error = error {
                callBackHandler(.none, error)
            } else {
                callBackHandler(user, .none)
            }
        }
    }

    private func authenticationDidComplete(authResult: AuthDataResult?,
                                           error: Error?,
                                           callBackHandler: @escaping UserCallBack) {
        if let error = error {
            callBackHandler(.none, error)
        } else if let authResult = authResult {
            let user = authResult.user
            var username = user.email ?? String()
            if let dotRange = username.range(of: "@") {
                username.removeSubrange(dotRange.lowerBound..<username.endIndex)
            }

            let loggedInUser = UserModel(userID: user.uid,
                                                 photoURL: user.photoURL as URL?,
                                                 displayName: user.displayName,
                                                 emailAddress: user.email,
                                                 userName: username,
                                                 password: .none)

            update(user: loggedInUser, callBackHandler: callBackHandler)
        }
    }
}
