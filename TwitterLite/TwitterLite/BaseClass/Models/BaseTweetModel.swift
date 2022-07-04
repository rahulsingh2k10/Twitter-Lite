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

    public init(jsonDict: JSONDict) { }

    public enum CodingKeys: String, CodingKey {
        case createdTimeStamp, caption
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        createdTimeStamp = try? container.decodeIfPresent(Double.self, forKey: .createdTimeStamp)
        caption = try? container.decodeIfPresent(String.self, forKey: .caption)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(createdTimeStamp, forKey: .createdTimeStamp)
        try? container.encodeIfPresent(caption, forKey: .caption)
    }
}
