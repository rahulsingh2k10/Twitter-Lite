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
                let loggedInUser = userDetail
                loggedInUser.userID = user.uid

                addUpdate(user: loggedInUser, callBackHandler: callBackHandler)
            }
        }
    }

    // MARK: - Private Methods -
    private func addUpdate(user: UserModel, callBackHandler: @escaping UserCallBack) {
        if let url = user.photoURL,
           let data = try? Data(contentsOf: url),
           let fileName = user.userID {
            PhotoEndPoint.uploadUserProfileImage(fileName: fileName).uploadAttachment(data: data) { url, error in
                if let error = error {
                    callBackHandler(.none, error)
                } else if let url = url {
                    continueAddUpdate(user: user,
                                      url: url,
                                      callBackHandler: callBackHandler)
                }
            }
        } else {
            callBackHandler(.none, FireBaseError.missingParameters)
        }
    }

    private func continueAddUpdate(user: UserModel, url: URL, callBackHandler: @escaping UserCallBack) {
        guard let userID = user.userID else {
            callBackHandler(.none, FireBaseError.missingParameters)

            return
        }

        let userModel = user
        userModel.photoURL = url
        userModel.password = .none
        userModel.userID = .none

        UserEndPoint.postUserDetails(id: userID).post(data: userModel) { (result: Result<UserModel, Error>) in
            switch result {
            case .success(let userModel):
                callBackHandler(userModel, .none)
            case .failure(let error):
                callBackHandler(.none, error)
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

            let loggedInUser = UserModel(jsonDict: JSONDict())
            loggedInUser.userID = user.uid
            loggedInUser.photoURL = user.photoURL
            loggedInUser.displayName = user.uid
            loggedInUser.emailAddress = user.email
            loggedInUser.userName = username
            loggedInUser.emailAddress = user.email

            addUpdate(user: loggedInUser, callBackHandler: callBackHandler)
        }
    }
}
