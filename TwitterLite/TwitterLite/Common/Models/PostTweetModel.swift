//
//  PostTweetModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import Foundation


class PostTweetModel: BaseTweetModel {
    var uid: String = Utils.shared.loggedInUser?.userID ?? String()

    public override init(jsonDict: JSONDict) {
        super.init(jsonDict: jsonDict)
    }

    public enum CodingKeys: String, CodingKey {
        case uid
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        uid = (try? container.decode(String.self, forKey: .uid)) ?? String()

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(uid, forKey: .uid)

        try super.encode(to: encoder)
    }
}
