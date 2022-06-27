//
//  FirebaseManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


struct FirebaseManager {
    static var shared: FirebaseManager = FirebaseManager()

    private init() {
        FirebaseApp.configure()
    }

    // MARK: - Public Methods -
    public func getClientID() -> String? {
        return FirebaseApp.app()?.options.clientID
    }

    public func signin(userDetail: LoggedInUserModel, callBackHandler: @escaping SignInCallBack) {
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
                                 callBackHandler: @escaping SignInCallBack) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)

        Auth.auth().signIn(with: credential) { authResult, error in
            authenticationDidComplete(authResult: authResult, error: error, callBackHandler: callBackHandler)
        }
    }

    public func createAccount(userDetail: LoggedInUserModel, callBackHandler: @escaping SignInCallBack) {
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
    private func update(user: LoggedInUserModel, callBackHandler: @escaping SignInCallBack) {
        updateUser(user: user) { error in
            if let error = error {
                callBackHandler(.none, error)
            } else {
                callBackHandler(user, .none)
            }
        }
    }

    private func authenticationDidComplete(authResult: AuthDataResult?,
                                           error: Error?,
                                           callBackHandler: @escaping SignInCallBack) {
        if let error = error {
            callBackHandler(.none, error)
        } else if let authResult = authResult {
            let user = authResult.user
            let loggedInUser = LoggedInUserModel(userID: user.uid,
                                                 photoURL: user.photoURL as URL?,
                                                 displayName: user.displayName,
                                                 emailAddress: user.email,
                                                 userName: user.email,
                                                 password: .none)

            update(user: loggedInUser, callBackHandler: callBackHandler)
        }
    }

    private func databaseReference() -> DatabaseReference {
        return Database.database().reference()
    }

    private func updateUser(user: LoggedInUserModel, callBackHandler: @escaping CallBack) {
        let ref = databaseReference().child(FirebaseDatabaseName.users.rawValue).child(user.userID!)

        if let data = try? JSONEncoder().encode(user),
           var jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            jsonDict.removeValue(forKey: "userID")

            ref.updateChildValues(jsonDict) { error, ref in
                callBackHandler(error)
            }
        }
    }
}
