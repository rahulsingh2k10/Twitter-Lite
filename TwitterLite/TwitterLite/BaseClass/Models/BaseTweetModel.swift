//
//  BaseTweetModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import Foundation


class BaseTweetModel: FirebaseModel {
    var tweetID: String?
    var caption: String?
    var createdTimeStamp: Double!
    var photoURL: [String]?

    public override init(jsonDict: JSONDict) {
        super.init(jsonDict: jsonDict)
    }

    public enum CodingKeys: String, CodingKey {
        case tweetID, caption, createdTimeStamp, photoURL
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        caption = try? container.decodeIfPresent(String.self, forKey: .caption)
        tweetID = try? container.decodeIfPresent(String.self, forKey: .tweetID)
        createdTimeStamp = try? container.decodeIfPresent(Double.self, forKey: .createdTimeStamp)
        photoURL = try? container.decodeIfPresent([String].self, forKey: .photoURL)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(caption, forKey: .caption)
        try? container.encodeIfPresent(tweetID, forKey: .tweetID)
        try? container.encodeIfPresent(createdTimeStamp, forKey: .createdTimeStamp)
        try? container.encodeIfPresent(photoURL, forKey: .photoURL)

        try super.encode(to: encoder)
    }
}
