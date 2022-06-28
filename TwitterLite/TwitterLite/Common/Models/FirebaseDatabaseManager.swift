//
//  FirebaseDatabaseManager.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage


struct FirebaseDatabaseManager {
    static var shared: FirebaseDatabaseManager = FirebaseDatabaseManager()

    private let databaseRef: DatabaseReference = Database.database().reference()
    private let storageRef: StorageReference = Storage.storage().reference()

    private init() {}

    // MARK: - Public Methods -
    public func updateUser(user: UserModel, callBackHandler: @escaping CallBack) {
        if let url = user.photoURL, let fileName = user.userID {
            uploadImage(url: url, fileName: fileName) { url, error in
                if let error = error {
                    callBackHandler(error)
                } else if let url = url {
                    continueUpdate(user: user, url: url, callBackHandler: callBackHandler)
                }
            }
        } else {
            continueUpdate(user: user, url: .none, callBackHandler: callBackHandler)
        }
    }

    public func fetchUserDetails(callBackHandler: @escaping CallBack) {
        guard let userID = FirebaseManager.shared.currentUser()?.uid else { return }
        
        databaseRef.child(FirebaseDatabaseName.users.rawValue).child(userID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? JSONDict else { return }

            var loggedInModel = dictionary.decode(UserModel.self)
            loggedInModel?.userID = userID
            Utils.shared.loggedInUser = loggedInModel

            callBackHandler(.none)
        }
    }

    // MARK: - Private Methods -
    private func uploadImage(url: URL,
                            fileName: String,
                            callBackHandler: @escaping URLCallBack) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    let ref = storageRef.child(FirebaseDatabaseName.profileImages.rawValue).child(fileName)
                    ref.putData(data, metadata: .none) { metadata, error in
                        ref.downloadURL { aURL, anError in
                            if let anError = anError {
                                callBackHandler(.none, anError)
                            } else if let aURL = aURL {
                                callBackHandler(aURL, .none)
                            }
                        }
                    }
                }
            }
        }
    }

    private func continueUpdate(user: UserModel, url: URL?, callBackHandler: @escaping CallBack) {
        // TODO: Need to Refactor this File
        let ref = databaseRef.child(FirebaseDatabaseName.users.rawValue).child(user.userID!)

        var userModel = user
        userModel.photoURL = url
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
