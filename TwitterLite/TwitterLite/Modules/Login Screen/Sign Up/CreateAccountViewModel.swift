//
//  CreateAccountViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


class CreateAccountViewModel: BaseViewModel {
    public var userModel: UserModel = UserModel(jsonDict: JSONDict())

    // MARK: - Public Methods -
    public func validateCreateUserModel() throws {
        guard let _ = userModel.photoURL else { throw LoginError.photoMissing }
        guard let name = userModel.displayName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty else { throw LoginError.displayNameMisssing }
        guard let emailAddress = userModel.emailAddress,
              emailAddress.isValidEmail() else { throw LoginError.emailAddressMissing }
        guard let userName = userModel.userName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !userName.isEmpty else { throw LoginError.userNameMissing }
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

    public func createUser(callBackHandler: @escaping UserCallBack) {
        FirebaseAuthenticationManager.shared.createAccount(userDetail: userModel,
                                                           callBackHandler: callBackHandler)
    }
}
