//
//  PhotoEndPoint.swift
//  TwitterLite
//
//  Created by Rahul Singh on 05/07/22.
//

import Foundation


enum PhotoEndPoint: FirebaseDatabaseEndPoint {
    case uploadUserProfileImage(fileName: String)
    case uploadImage(fileName: String)
    case deleteImage

    var path: String {
        switch self {
        case .uploadUserProfileImage(let fileName):
            return "\(FirebaseDatabaseName.profileImage.rawValue)/\(fileName)"
        case .uploadImage(let fileName):
            return "\(FirebaseDatabaseName.tweetImage.rawValue)/\(fileName)"
        case .deleteImage:
            return "\(FirebaseDatabaseName.tweetImage.rawValue)"
        }
    }
}
