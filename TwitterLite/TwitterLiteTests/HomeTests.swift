//
//  HomeTests.swift
//  TwitterLiteTests
//
//  Created by Rahul Singh on 07/07/22.
//

import XCTest
@testable import TwitterLite


class HomeTests: XCTestCase {
    private var homeVM: HomeViewModel!

    override func setUpWithError() throws {
        try? super.setUpWithError()

        homeVM = HomeViewModel()
        setTweetList(with: 100)
    }

    override func tearDownWithError() throws {
        homeVM = .none

        try? super.tearDownWithError()
    }

    func testTableViewShouldCallAPI() {
        setTweetList(with: 10)
        XCTAssertTrue(homeVM.shouldFetchData(index: 5))

        setTweetList(with: 20)
        XCTAssertTrue(homeVM.shouldFetchData(index: 15))

        setTweetList(with: 30)
        XCTAssertTrue(homeVM.shouldFetchData(index: 25))
    }

    func testTableViewShouldNotCallAPI() {
        XCTAssertFalse(homeVM.shouldFetchData(index: 0))

        XCTAssertFalse(homeVM.shouldFetchData(index: 9))

        XCTAssertFalse(homeVM.shouldFetchData(index: 20))

        XCTAssertFalse(homeVM.shouldFetchData(index: 40))
    }

    func testCreateTweet() throws {
        let uid = FirebaseAuthenticationManager.shared.currentUser()?.uid
        try XCTSkipUnless((uid != .none),
                          "user needs to be logged in before tweeting.")

        let tweetID = FirebaseDatabaseManager.shared.generateKey()

        let tweetModel = PostTweetModel(jsonDict: JSONDict())
        tweetModel.tweetID = tweetID
        tweetModel.uid = uid!
        tweetModel.caption = "Tweet from XCT Unit Test \(Int.random(in: 0...1000))"
        tweetModel.createdTimeStamp = Double(Date().timeIntervalSince1970)

        let expectation = expectation(description: "SigninUser")

        TweetEndPoint.postTweet(id: tweetID).post(data: tweetModel) { (result: Result<PostTweetModel, Error>) in
            switch result {
            case .success(_):
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNil(error)
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    // MARK: - Private Methods -
    private func setTweetList(with count: Int) {
        homeVM.tweetList = (0..<count).compactMap() { index -> ViewTweetModel in
            ViewTweetModel(jsonDict: JSONDict())
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
