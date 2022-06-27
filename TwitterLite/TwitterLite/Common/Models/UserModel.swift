//
//  UserModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


struct UserModel: Codable {
    var userID: String?
    var photoURL: URL?
    var displayName: String?
    var emailAddress: String?
    var userName: String?
    var password: String?
}
