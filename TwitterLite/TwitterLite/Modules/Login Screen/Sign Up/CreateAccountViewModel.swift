//
//  CreateAccountViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


class CreateAccountViewModel: BaseViewModel {
    public var userModel: UserModel = UserModel()

    // MARK: - Public Methods -
    public func isModelValid() -> Bool {
        guard let _ = userModel.photoURL else { return false }
        guard let name = userModel.displayName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else { return false }
        guard let emailAddress = userModel.emailAddress,
              emailAddress.isValidEmail() else { return false }
        guard let userName = userModel.userName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userName.isEmpty else { return false }
        guard let password = userModel.password?.trimmingCharacters(in: .whitespacesAndNewlines),
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

    public func createUser(callBackHandler: @escaping SignInCallBack) {
        FirebaseManager.shared.createAccount(userDetail: userModel, callBackHandler: callBackHandler)
    }
}
