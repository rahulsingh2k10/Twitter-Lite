//
//  NewTweetViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import Foundation


class NewTweetViewModel: BaseViewModel {
    public var tweetModel = PostTweetModel(jsonDict: JSONDict())

    // MARK: - Public Methods -
    public func addTweet(callBackHandler: @escaping CallBack) {
        FirebaseDatabaseManager.shared.save(tweet: tweetModel) { error in
            callBackHandler(error)
        }
    }
}
