//
//  TweetsTableViewCell.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import UIKit


class TweetsTableViewCell: UITableViewCell, NibReusable {
    public var deleteTweetCallBack: ((ViewTweetModel) -> ())?

    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var userDetailLabel: UILabel!
    @IBOutlet weak private var captionlabel: UILabel!
    @IBOutlet weak private var timeStampLabel: UILabel!

    private var tweetModel: ViewTweetModel!

    //MARK: - Public Methods -
    public func loadData(tweetModel: ViewTweetModel) {
        self.tweetModel = tweetModel

        profileView.loadImage(url: tweetModel.user?.photoURL)
        userDetailLabel.text = "\(tweetModel.user?.displayName ?? String()) • @\(tweetModel.user?.userName ?? String())"
        timeStampLabel.text = Date.getDate(from: tweetModel.createdTimeStamp)
        captionlabel.text = tweetModel.caption
    }

    //MARK: - Action Methods -
    @IBAction func deleteTweet(_ sender: Any) {
        deleteTweetCallBack?(tweetModel)
    }
}
