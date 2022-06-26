//
//  LoggedInUserModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import Foundation


struct LoggedInUserModel: Codable {
    var userName: String?
    var displayName: String?
    var photoURL: URL?
    var phoneNumber: String?
}
