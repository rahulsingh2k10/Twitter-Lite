//
//  TweetsTableViewCell.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import UIKit


class TweetsTableViewCell: UITableViewCell, NibReusable {
    private var tweetModel: ViewTweetModel!

    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var userDetailLabel: UILabel!
    @IBOutlet weak private var captionlabel: UILabel!
    @IBOutlet weak private var timeStampLabel: UILabel!

    public func loadData(tweetModel: ViewTweetModel) {
        self.tweetModel = tweetModel

        profileView.loadImage(url: tweetModel.user?.photoURL)
        userDetailLabel.text = "\(tweetModel.user?.displayName ?? String()) • @\(tweetModel.user?.userName ?? String())"
        timeStampLabel.text = Date.getDate(from: tweetModel.createdTimeStamp)
        captionlabel.text = tweetModel.caption
    }
}
