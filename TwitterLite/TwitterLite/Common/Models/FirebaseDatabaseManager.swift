//
//  FirebaseDatabaseManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import Foundation
import FirebaseDatabase


struct FirebaseDatabaseManager {
    static var shared: FirebaseDatabaseManager = FirebaseDatabaseManager()

    private let DB_REF = Database.database().reference()

    private init() {}

    public func updateUser(user: UserModel, callBackHandler: @escaping CallBack) {
        let ref = DB_REF.child(FirebaseDatabaseName.users.rawValue).child(user.userID!)

        var userModel = user
        userModel.password = .none
        userModel.userID = .none

        if let data = try? JSONEncoder().encode(userModel),
           let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            ref.updateChildValues(jsonDict) { error, ref in
                callBackHandler(error)
            }
        }
    }
}
