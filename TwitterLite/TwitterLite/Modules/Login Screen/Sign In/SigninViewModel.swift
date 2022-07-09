//
//  SigninViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import Foundation


class SigninViewModel: BaseViewModel {
    public var userModel: UserModel = UserModel(jsonDict: JSONDict())

    // MARK: - Public Methods -
    public func validateSiginUserModel() throws {
        guard let emailAddress = userModel.emailAddress,
              emailAddress.isValidEmail() else { throw LoginError.emailAddressMissing }
        guard let password = userModel.password?.trimmingCharacters(in: .whitespacesAndNewlines),
              !password.isEmpty else { throw LoginError.passwordMissing }

        /*
         * At least 8 characters
         * At least one capital letter
         * At least one lowercase letter
         * At least one digit
         * At least one special character
         */
        let passwordPattern = "(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[ !$%&?.@_-])"
        let result = password.range(of: passwordPattern, options: .regularExpression)
        if (result == .none) {
            throw LoginError.passwordCriteriaMissing
        }
    }

    public func signInUser(callBackHandler: @escaping UserCallBack) {
        FirebaseAuthenticationManager.shared.signIn(userDetail: userModel,
                                                    callBackHandler: callBackHandler)
    }
}
