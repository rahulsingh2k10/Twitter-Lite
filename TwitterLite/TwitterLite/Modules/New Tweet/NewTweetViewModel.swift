//
//  NewTweetViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import Foundation


class NewTweetViewModel: BaseViewModel {
    public var tweetModel = PostTweetModel(jsonDict: JSONDict())

    // MARK: - Public Methods -
    public func shouldEnableSendingTweet() -> Bool {
        let isTextAvailable = !(tweetModel.caption?.isEmpty ?? true)
        let isPhotosAvailable = !(tweetModel.photos?.isEmpty ?? true)

        return isTextAvailable || isPhotosAvailable
    }

    public func addTweet(callBackHandler: @escaping CallBack) {
        let tweetID = FirebaseDatabaseManager.shared.generateKey()
        tweetModel.tweetID = tweetID

        if let photos = tweetModel.photos {
            let dispatchQueue = DispatchGroup()

            tweetModel.photoURL = []

            for (index, photo) in photos.enumerated() {
                dispatchQueue.enter()

                let fileName = "\(tweetID)_\(index)"
                if let data = photo.image.cache_toData() {
                    PhotoEndPoint.uploadImage(fileName: fileName).uploadAttachment(data: data) {[weak self] url, error in
                        guard let strongSelf = self else { return }

                        if let url = url {
                            strongSelf.tweetModel.photoURL?.append(url.absoluteString)
                        }

                        dispatchQueue.leave()
                    }
                }
            }

            dispatchQueue.notify(queue: .main) {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tweetModel.photos = .none
                strongSelf.continueAddTweet(tweetID: tweetID, callBackHandler: callBackHandler)
            }
        } else {
            continueAddTweet(tweetID: tweetID, callBackHandler: callBackHandler)
        }
    }

    private func continueAddTweet(tweetID: String, callBackHandler: @escaping CallBack) {
        tweetModel.createdTimeStamp = Double(Date().timeIntervalSince1970)

        TweetEndPoint.postTweet(id: tweetID).post(data: tweetModel) { (result: Result<PostTweetModel, Error>) in
            switch result {
            case .success(_):
                callBackHandler(.none)
            case .failure(let error):
                callBackHandler(error)
            }
        }
    }
}
