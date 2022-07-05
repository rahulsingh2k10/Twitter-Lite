//
//  UserModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


class UserModel: FirebaseModel {
    var userID: String?
    var photoURL: URL?
    var displayName: String?
    var emailAddress: String?
    var userName: String?
    var password: String?

    public override init(jsonDict: JSONDict) {
        super.init(jsonDict: jsonDict)
    }

    public enum CodingKeys: String, CodingKey {
        case userID, photoURL, displayName, emailAddress, userName, password
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        userID = try? container.decodeIfPresent(String.self, forKey: .userID)
        photoURL = try? container.decodeIfPresent(URL.self, forKey: .photoURL)
        displayName = try? container.decodeIfPresent(String.self, forKey: .displayName)
        emailAddress = try? container.decodeIfPresent(String.self, forKey: .emailAddress)
        userName = try? container.decodeIfPresent(String.self, forKey: .userName)
        password = try? container.decodeIfPresent(String.self, forKey: .password)

        try super.init(from: decoder)
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try? container.encodeIfPresent(userID, forKey: .userID)
        try? container.encodeIfPresent(photoURL, forKey: .photoURL)
        try? container.encodeIfPresent(displayName, forKey: .displayName)
        try? container.encodeIfPresent(emailAddress, forKey: .emailAddress)
        try? container.encodeIfPresent(userName, forKey: .userName)
        try? container.encodeIfPresent(password, forKey: .password)

        try super.encode(to: encoder)
    }
}
