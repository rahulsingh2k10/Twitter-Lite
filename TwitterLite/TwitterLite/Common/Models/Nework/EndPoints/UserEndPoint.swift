//
//  UserEndPoint.swift
//  TwitterLite
//
//  Created by Rahul Singh on 04/07/22.
//

import Foundation


enum UserEndPoint: FirebaseDatabaseEndPoint {
    case getLoggedInUserDetail
    case getUserDetails(id: String)
    case postUserDetails(id: String)

    var path: String {
        switch self {
        case .getLoggedInUserDetail:
            guard let userID = FirebaseAuthenticationManager.shared.currentUser()?.uid else { return String() }

            return "\(FirebaseDatabaseName.users.rawValue)/\(userID)"
        case .getUserDetails(let userID), .postUserDetails(let userID):
            return "\(FirebaseDatabaseName.users.rawValue)/\(userID)"
        }
    }
}
