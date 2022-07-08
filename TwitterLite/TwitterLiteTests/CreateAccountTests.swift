//
//  CreateAccountTests.swift
//  TwitterLiteTests
//
//  Created by Rahul Singh on 07/07/22.
//

import XCTest
@testable import TwitterLite


class CreateAccountTests: XCTestCase {
    private var createAccountVM: CreateAccountViewModel!

    override func setUpWithError() throws {
        try? super.setUpWithError()

        createAccountVM = CreateAccountViewModel()
    }

    override func tearDownWithError() throws {
        createAccountVM = .none

        try? super.tearDownWithError()
    }

    func testEmptyCreateAccountModel() {
        let userModel = UserModel(jsonDict: JSONDict())
        createAccountVM.userModel = userModel

        XCTAssertFalse(createAccountVM.isModelValid())
    }

    func testCreateAccountModelWithOnlyImage() {
        let userModel = UserModel(jsonDict: JSONDict())
        userModel.photoURL = URL(string: "https://media.istockphoto.com/photos/twitter-3d-logo-3d-render-image-illustration-picture-id1383510053?s=612x612")

        
        createAccountVM.userModel = userModel

        XCTAssertNil(userModel.userName)
        XCTAssertFalse(createAccountVM.isModelValid())
    }

    func testValidCreateAccountModel() {
        let userModel = UserModel(jsonDict: JSONDict())
        userModel.displayName = "Test User"
        userModel.emailAddress = "testuser4@gmail.com"
        userModel.userName = "testuser4"
        userModel.password = "Testuser4@123"
        userModel.photoURL = URL(string: "https://media.istockphoto.com/photos/twitter-3d-logo-3d-render-image-illustration-picture-id1383510053?s=612x612")
        createAccountVM.userModel = userModel

        XCTAssertNotNil(userModel.userName)
        XCTAssertTrue(createAccountVM.isModelValid())
    }

    func testSuccessUserLogin() {
        let expectation = expectation(description: "SigninUser")

        let userModel = UserModel(jsonDict: JSONDict())
        userModel.emailAddress = "testuser4@gmail.com"
        userModel.password = "RahulSingh@123"

        FirebaseAuthenticationManager.shared.signIn(userDetail: userModel) { userModel, error in
            if userModel !== .none {
                expectation.fulfill()
            } else if let error = error {
                XCTFail("Failed: \(error.localizedDescription)")
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    func testFailedUserLogin() {
        let expectation = expectation(description: "SigninUser")

        let userModel = UserModel(jsonDict: JSONDict())
        userModel.emailAddress = "testuser4@gmail.com"
        userModel.password = "RahulSingh@1234"

        FirebaseAuthenticationManager.shared.signIn(userDetail: userModel) { userModel, error in
            if userModel !== .none {
                XCTAssertNil(userModel)
            } else if let _ = error {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
