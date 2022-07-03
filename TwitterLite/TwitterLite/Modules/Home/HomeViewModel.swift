//
//  HomeViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import Foundation
import UIKit


class HomeViewModel: BaseViewModel {
    public var tweetList: [ViewTweetModel] = []
    public var lastCreatedDateTimeStamp: Double?

    private var pageSize: UInt = (UIDevice.current.userInterfaceIdiom == .phone ? 10: 20)

    // MAKR: - Public Methods -
    public func fetchLatestTweets(callBackHandler: @escaping TweetsCallBack) {
        if let timeStamp = tweetList.first?.createdTimeStamp {
            FirebaseDatabaseManager.shared.fetchTweets(latestTweetTimeStamp: timeStamp,
                                                       callbackHandler: callBackHandler)
        } else {
            callBackHandler(.none, FireBaseError.missingParameters)
        }
    }

    public func fetchTweets(callBackHandler: @escaping TweetsCallBack) {
        FirebaseDatabaseManager.shared.fetchTweets(startPoint: lastCreatedDateTimeStamp,
                                                   pageSize: pageSize,
                                                   callbackHandler: callBackHandler)
    }

    public func delete(tweetModel: ViewTweetModel, callBackHandler: @escaping CallBack) {
        FirebaseDatabaseManager.shared.deleteTweet(tweetID: tweetModel.tweetID!, callbackHandler: callBackHandler)
    }

    public func shouldFetchData(index: Double) -> Bool {
        let pageSize = Double(self.pageSize)
        let center = Double(pageSize/2)
        let actualTweetCount = Double(tweetList.count)
        let tweetCount = actualTweetCount.rounded(to: pageSize, roundingRule: .down)
        let nextIndexToCall = Double(floor(tweetCount - pageSize + center))

        if ((index != 0) &&
            ((index.truncatingRemainder(dividingBy: center)) == 0) &&
            (nextIndexToCall == index)) {
            return true
        } else {
            return false
        }
    }
}
