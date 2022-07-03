//
//  ViewTweetModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import Foundation


class ViewTweetModel: PostTweetModel {
    var tweetID: String?
    var user: UserModel?

    public override init(jsonDict: JSONDict) {
        super.init(jsonDict: jsonDict)
    }

    public enum CodingKeys: String, CodingKey {
        case tweetID, user
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        tweetID = try? container.decodeIfPresent(String.self, forKey: .tweetID)
        user = try? container.decode(UserModel.self, forKey: .user)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(tweetID, forKey: .tweetID)
        try? container.encodeIfPresent(user, forKey: .user)

        try super.encode(to: encoder)
    }
}
