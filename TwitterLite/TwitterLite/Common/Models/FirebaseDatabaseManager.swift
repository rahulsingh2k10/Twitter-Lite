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
        if let url = user.photoURL,
           let fileName = user.userID,
           let data = try? Data(contentsOf: url) {
            upload(imageData: data,
                   databaseName: FirebaseDatabaseName.profileImages.rawValue,
                   fileName: fileName) { url, error in
                if let error = error {
                    callBackHandler(error)
                } else if let url = url {
                    continueUpdate(user: user, url: url.first,
                                   callBackHandler: callBackHandler)
                }
            }
        } else {
            continueUpdate(user: user, url: .none, callBackHandler: callBackHandler)
        }
    }

    public func fetchUserDetails(userID: String,
                                 callBackHandler: @escaping UserCallBack) {
        databaseRef.child(FirebaseDatabaseName.users.rawValue)
            .child(userID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? JSONDict else { return }

                var userModel = dictionary.decode(UserModel.self)
                userModel?.userID = userID

                callBackHandler(userModel, .none)
            }
    }

    public func fetchLoggedInUserDetails(callBackHandler: @escaping CallBack) {
        guard let userID = FirebaseManager.shared.currentUser()?.uid else { return }

        databaseRef.child(FirebaseDatabaseName.users.rawValue)
            .child(userID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? JSONDict else { return }

                var loggedInModel = dictionary.decode(UserModel.self)
                loggedInModel?.userID = userID
                Utils.shared.loggedInUser = loggedInModel

                callBackHandler(.none)
            }
    }

    public func fetchTweets(startPoint: Double?,
                            pageSize: UInt,
                            callbackHandler: @escaping TweetsCallBack) {
        let ref = databaseRef.child(FirebaseDatabaseName.tweets.rawValue).queryOrdered(byChild: "createdTimeStamp")

        if startPoint == .none {
            ref.queryLimited(toLast: pageSize)
                .observeSingleEvent(of: .value) { snapshot in
                    fetchTweetsComplete(snapshot: snapshot,
                                        shouldRemoveLast: false,
                                        callbackHandler: callbackHandler)
                }
        } else {
            ref.queryEnding(atValue: startPoint).queryLimited(toLast: (pageSize + 1))
                .observeSingleEvent(of: .value) { snapshot in
                    fetchTweetsComplete(snapshot: snapshot, callbackHandler: callbackHandler)
                }
        }
    }

    public func save(tweet: PostTweetModel, callBackHandler: @escaping CallBack) {
        let tempTweetModel = tweet

        let ref = databaseRef.child(FirebaseDatabaseName.tweets.rawValue).childByAutoId()

        if let photos = tempTweetModel.photos {
            uploadTweetPhotos(tweetID: ref.key!,
                              photos: photos) { urls, error in
                tempTweetModel.createdTimeStamp = Double(Date().timeIntervalSince1970)

                var jsonDict = tempTweetModel.JSONDictionary
                jsonDict!["photoURL"] = urls?.compactMap { ($0 as URL).absoluteString } as? AnyObject
                jsonDict!["photos"] = .none
                
                continueSave(databaseRef: ref,
                             jsonDict: jsonDict!) { error in
                    callBackHandler(error)
                }
            }
        } else {
            tempTweetModel.createdTimeStamp = Double(Date().timeIntervalSince1970)
            tempTweetModel.photos = .none

            continueSave(databaseRef: ref,
                         jsonDict: tempTweetModel.JSONDictionary!) { error in
                callBackHandler(error)
            }
        }
    }

    public func deleteTweet(tweetID: String, callbackHandler: @escaping CallBack) {
        let ref = databaseRef.child(FirebaseDatabaseName.tweets.rawValue)

        ref.child(tweetID).removeValue { error, ref in
            callbackHandler(error)
        }
    }

    // MARK: - Private Methods -
    private func fetchTweetsComplete(snapshot: DataSnapshot,
                                     shouldRemoveLast: Bool = true,
                                     callbackHandler: @escaping TweetsCallBack) {
        var tweets: [ViewTweetModel] = []

        for s in snapshot.children.allObjects as! [DataSnapshot] {
            let value = s.value as! JSONDict
            if let tweetModel = value.decode(ViewTweetModel.self) {
                tweetModel.tweetID = s.key

                tweets.append(tweetModel)
            }
        }

        let dispatchGroup = DispatchGroup()

        for tweet in tweets {
            if tweet.uid == Utils.shared.loggedInUser?.userID {
                tweet.user = Utils.shared.loggedInUser
            } else {
                dispatchGroup.enter()

                fetchUserDetails(userID: tweet.uid) { userModel, error in
                    tweet.user = userModel

                    dispatchGroup.leave()
                }
            }
        }

        if shouldRemoveLast {
            tweets.removeLast()
        }

        dispatchGroup.notify(queue: .main) {
            callbackHandler(tweets.reversed(), .none)
        }
    }

    private func continueSave(databaseRef: DatabaseReference,
                              jsonDict: JSONDict,
                              callBackHandler: @escaping CallBack) {
        databaseRef.updateChildValues(jsonDict) { error, databaseRef in
            callBackHandler(error)
        }
    }

    private func uploadTweetPhotos(tweetID: String,
                                   photos: [ImageWrapper],
                                   callBackHandler: @escaping URLCallBack) {
        let dispatchGroup = DispatchGroup()

        var photoURL: [URL] = []

        for (index, photo) in photos.enumerated() {
            dispatchGroup.enter()
            upload(imageData: photo.image.cache_toData()!,
                   databaseName: FirebaseDatabaseName.tweetImages.rawValue,
                   fileName: "\(tweetID)_\(index)") { url, error in
                if let url = url?.first {
                    photoURL.append(url)
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            callBackHandler(photoURL, .none)
        }
    }

    private func upload(imageData: Data,
                        databaseName: String,
                        fileName: String,
                        callBackHandler: @escaping URLCallBack) {
        let ref = storageRef.child(databaseName).child(fileName)

        ref.putData(imageData, metadata: .none) { metadata, error in
            ref.downloadURL { aURL, anError in
                if let anError = anError {
                    callBackHandler(.none, anError)
                } else if let aURL = aURL {
                    callBackHandler([aURL], .none)
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
