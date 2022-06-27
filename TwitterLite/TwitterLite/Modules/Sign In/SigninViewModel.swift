//
//  SigninViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import Foundation


class SigninViewModel: BaseViewModel {
    public var model: LoggedInUserModel = LoggedInUserModel()

    // MARK: - Public Methods -
    public func isModelValid() -> Bool {
        guard let emailAddress = model.emailAddress,
              emailAddress.isValidEmail() else { return false }
        guard let password = model.password?.trimmingCharacters(in: .whitespacesAndNewlines),
              !password.isEmpty else { return false }

        /*
         * At least 8 characters
         * At least one capital letter
         * At least one lowercase letter
         * At least one digit
         * At least one special character
         */
        let passwordPattern = "(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[ !$%&?.@_-])"
        let result = password.range(of: passwordPattern, options: .regularExpression)
        let validPassword = (result != .none)

        return validPassword
    }

    public func signInUser(callBackHandler: @escaping SignInCallBack) {
        FirebaseManager.shared.signin(userDetail: model, callBackHandler: callBackHandler)
    }
}
