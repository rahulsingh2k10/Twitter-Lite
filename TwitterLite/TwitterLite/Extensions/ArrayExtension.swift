//
//  ArrayExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 28/06/22.
//

import Foundation


extension Array {
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        if let jsonData = (try? JSONSerialization.data(withJSONObject: self, options: [])) {
            return try? JSONDecoder().decode(type, from: jsonData)
        } else {
            return .none
        }
    }

    func encode<T>(_ value: T) -> Any? where T: Encodable {
        if let jsonData = try? JSONEncoder().encode(value),
           let value = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) {
            return value
        } else {
            return .none
        }
    }
}
