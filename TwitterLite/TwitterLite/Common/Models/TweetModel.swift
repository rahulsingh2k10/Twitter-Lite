//
//  TweetModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import Foundation


struct TweetModel: Codable {
    var uid: String = Utils.shared.loggedInUser?.userID ?? String()
    var createdTimeStamp: Int!
    var caption: String?
    var photos: [ImageWrapper]?
}
