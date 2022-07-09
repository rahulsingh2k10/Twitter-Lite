//
//  SigninTests.swift
//  TwitterLiteTests
//
//  Created by Rahul Singh on 07/07/22.
//

import XCTest
@testable import TwitterLite


class SigninTests: XCTestCase {
    private var signinVM: SigninViewModel!

    override func setUpWithError() throws {
        try? super.setUpWithError()

        signinVM = SigninViewModel()
    }

    override func tearDownWithError() throws {
        signinVM = .none

        try? super.tearDownWithError()
    }

    func testEmptySigInModel() {
        let userModel = UserModel(jsonDict: JSONDict())
        signinVM.userModel = userModel

        XCTAssertThrowsError(try signinVM.validateSiginUserModel()) { error in
            XCTAssertEqual(error as! LoginError, LoginError.emailAddressMissing)
         }
    }

    func testValidSignInModel() {
        let userModel = UserModel(jsonDict: JSONDict())
        userModel.emailAddress = "testuser4@gmail.com"
        userModel.password = "Testuser4@123"
        signinVM.userModel = userModel

        XCTAssertNotNil(userModel.emailAddress, FireBaseError.missingParameters.errorDescription!)

        XCTAssertNoThrow(try signinVM.validateSiginUserModel())
    }

    func testInvalidSignInModel() {
        let userModel = UserModel(jsonDict: JSONDict())
        userModel.emailAddress = "testuser4@gmail.com"
        userModel.password = "Testuser"
        signinVM.userModel = userModel

        XCTAssertThrowsError(try signinVM.validateSiginUserModel()) {error in
            XCTAssertNotNil(error)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
