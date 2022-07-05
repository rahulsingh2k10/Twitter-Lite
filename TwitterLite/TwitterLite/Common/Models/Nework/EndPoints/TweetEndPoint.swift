//
//  TweetEndPoint.swift
//  TwitterLite
//
//  Created by Rahul Singh on 04/07/22.
//

import Foundation


enum TweetEndPoint: FirebaseDatabaseEndPoint {
    case postTweet(id: String)
    case deleteTweet(id: String)
    case getTweets

    var path: String {
        switch self {
        case .getTweets:
            return FirebaseDatabaseName.tweets.rawValue
        case .postTweet(id: let id), .deleteTweet(let id):
            return "\(FirebaseDatabaseName.tweets.rawValue)/\(id)"
        }
    }
}
