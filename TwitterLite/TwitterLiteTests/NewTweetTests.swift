//
//  NewTweetTests.swift
//  TwitterLiteTests
//
//  Created by Rahul Singh on 07/07/22.
//

import XCTest
@testable import TwitterLite


class NewTweetTests: XCTestCase {
    private var newTweetVM: NewTweetViewModel!

    override func setUpWithError() throws {
        try? super.setUpWithError()

        newTweetVM = NewTweetViewModel()
    }

    override func tearDownWithError() throws {
        newTweetVM = .none

        try? super.tearDownWithError()
    }

    func testShouldAllowSendingTweet() {
        newTweetVM.tweetModel.caption = "Some Tweet"
        XCTAssertTrue(newTweetVM.shouldEnableSendingTweet())
    }

    func testShouldNotAllowSendingTweet() {
        XCTAssertFalse(newTweetVM.shouldEnableSendingTweet())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
