//
//  FirebaseModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 06/07/22.
//

import Foundation


class FirebaseModel: Codable {
    var modelID: String?

    public init(jsonDict: JSONDict) { }

    public enum CodingKeys: String, CodingKey {
        case modelID
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        modelID = try? container.decodeIfPresent(String.self, forKey: .modelID)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(modelID, forKey: .modelID)
    }
}
