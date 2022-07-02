//
//  EncodableExtensions.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import Foundation


extension Encodable {
    var JSONDictionary: JSONDict? {
        if let data = try? JSONEncoder().encode(self),
           let jsonDict = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSONDict {
            return jsonDict
        } else {
            return .none
        }
    }

    var JSONArray: [Any]? {
        if let jsonData = try? JSONEncoder().encode(self),
           let jsonList = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [Any] {
            return jsonList
        } else {
            return .none
        }
    }
}
