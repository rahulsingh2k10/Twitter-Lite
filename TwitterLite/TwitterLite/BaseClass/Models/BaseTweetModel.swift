//
//  BaseTweetModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import Foundation


class BaseTweetModel: Codable {
    var createdTimeStamp: Double!
    var caption: String?
    var photos: [ImageWrapper]?

    public init(jsonDict: JSONDict) { }

    public enum CodingKeys: String, CodingKey {
        case createdTimeStamp, caption, photos
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        createdTimeStamp = try? container.decodeIfPresent(Double.self, forKey: .createdTimeStamp)
        caption = try? container.decodeIfPresent(String.self, forKey: .caption)
        photos = try? container.decodeIfPresent([ImageWrapper].self, forKey: .photos)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(createdTimeStamp, forKey: .createdTimeStamp)
        try? container.encodeIfPresent(caption, forKey: .caption)
        try? container.encodeIfPresent(photos, forKey: .photos)
    }
}
