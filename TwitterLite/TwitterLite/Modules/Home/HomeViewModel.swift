//
//  HomeViewModel.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import Foundation
import UIKit


class HomeViewModel: BaseViewModel {
    public var tweetList: [ViewTweetModel] = []
    public var lastCreatedDateTimeStamp: Double?

    private var pageSize: UInt = (UIDevice.current.userInterfaceIdiom == .phone ? 10: 20)
    private var sortKey = "createdTimeStamp"

    // MAKR: - Public Methods -
    public func signOutUser(callBackHandlder: @escaping CallBack) {
        FirebaseAuthenticationManager.shared.signOut(callBack: callBackHandlder)
    }

    public func getloggedInUserDetail(callBackHandler: @escaping CallBack) {
        UserEndPoint.getLoggedInUserDetail.fetchWithoutObserving() {(result: Result<UserModel, Error>) in
            switch result {
            case .success(let userModel):
                userModel.userID = FirebaseAuthenticationManager.shared.currentUser()?.uid
                Utils.shared.loggedInUser = userModel

                callBackHandler(.none)
            case .failure(let error):
                callBackHandler(error)
            }
        }
    }

    public func fetchLatestTweets(callBackHandler: @escaping TweetsCallBack) {
        if let timeStamp = tweetList.first?.createdTimeStamp {
            TweetEndPoint.getTweets
                .fetchWithoutObserving(queryKey: sortKey,
                                       queryStarting: timeStamp) {[weak self] (result: Result<[ViewTweetModel], Error>) in
                    guard let strongSelf = self else { return }

                    strongSelf.fetchUserDetails(result: result) { tweetModelList, error in
                        if let tweetModelList = tweetModelList, !tweetModelList.isEmpty {
                            var sortedTweets = tweetModelList.sorted { $0.createdTimeStamp > $1.createdTimeStamp }
                            sortedTweets.removeLast()

                            callBackHandler(sortedTweets, error)
                        } else {
                            callBackHandler(.none, error)
                        }
                    }
                }
        } else {
            callBackHandler(.none, FireBaseError.missingParameters)
        }
    }

    public func fetchTweets(callBackHandler: @escaping TweetsCallBack) {
        TweetEndPoint.getTweets
            .fetchWithoutObserving(pageSize: (lastCreatedDateTimeStamp == . none) ? pageSize : pageSize + 1,
                                   queryKey: sortKey,
                                   queryEnding: lastCreatedDateTimeStamp) {[weak self] (result: Result<[ViewTweetModel], Error>) in
                guard let strongSelf = self else { return }

                strongSelf.fetchUserDetails(result: result) { tweetModelList, error in
                    if let tweetModelList = tweetModelList, !tweetModelList.isEmpty {
                        var sortedTweets = tweetModelList.sorted { $0.createdTimeStamp > $1.createdTimeStamp }

                        if strongSelf.lastCreatedDateTimeStamp != .none {
                            sortedTweets.removeFirst()
                        }

                        callBackHandler(sortedTweets, error)
                    } else {
                        callBackHandler(.none, error)
                    }
                }
            }
    }

    public func delete(tweetModel: ViewTweetModel, callBackHandler: @escaping CallBack) {
        guard let tweetID = tweetModel.tweetID else {
            callBackHandler(FireBaseError.missingParameters)

            return
        }

        TweetEndPoint.deleteTweet(id: tweetID).delete(callBackHandler: callBackHandler)
    }

    public func shouldFetchData(index: Double) -> Bool {
        let pageSize = Double(self.pageSize)
        let center = Double(pageSize/2)
        let actualTweetCount = Double(tweetList.count)
        let tweetCount = actualTweetCount.rounded(to: pageSize, roundingRule: .down)
        let nextIndexToCall = Double(floor(tweetCount - pageSize + center))

        if ((index != 0) &&
            ((index.truncatingRemainder(dividingBy: center)) == 0) &&
            (nextIndexToCall == index)) {
            return true
        } else {
            return false
        }
    }

    // MARK: - Private Methods -
    private func fetchUserDetails(result: Result<[ViewTweetModel], Error>,
                                  callBackHandler: @escaping TweetsCallBack) {
        switch result {
        case .success(let tweetModelList):
            let dispatchGroup = DispatchGroup()

            for tweet in tweetModelList {
                if tweet.uid == Utils.shared.loggedInUser?.userID {
                    tweet.user = Utils.shared.loggedInUser
                } else {
                    dispatchGroup.enter()

                    UserEndPoint.getUserDetails(id: tweet.uid).fetchWithoutObserving() { (result: Result<UserModel, Error>) in
                        switch result {
                        case .success(let userModel):
                            tweet.user = userModel
                        default: break
                        }

                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                callBackHandler(tweetModelList, .none)
            }
        case .failure(let error):
            callBackHandler(.none, error)
        }
    }
}
