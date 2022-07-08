//
//  TweetsTableViewCell.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import UIKit


class TweetsTableViewCell: UITableViewCell, NibReusable {
    public var deleteTweetCallBack: ((ViewTweetModel) -> ())?

    @IBOutlet weak private var photoGalleryView: PhotoGalleryView!
    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var userDetailLabel: UILabel!
    @IBOutlet weak private var captionlabel: UILabel!
    @IBOutlet weak private var timeStampLabel: UILabel!
    @IBOutlet weak private var photoHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var deleteButton: RoundedButton!
    private var tweetModel: ViewTweetModel!

    //MARK: - Public Methods -
    public func loadData(tweetModel: ViewTweetModel, hideDeleteButton: Bool = true) {
        self.tweetModel = tweetModel

        if let loggedInUserID = Utils.shared.loggedInUser?.userID,
           loggedInUserID == tweetModel.uid {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }

        profileView.loadImage(url: tweetModel.user?.photoURL)

        userDetailLabel.text = "\(tweetModel.user?.displayName ?? String()) • @\(tweetModel.user?.userName ?? String())"
        timeStampLabel.text = Date.getDate(from: tweetModel.createdTimeStamp)
        captionlabel.text = tweetModel.caption

        if let photos = tweetModel.photoURL, photos.count > 0 {
            photoHeightConstraint.constant = 75.0
            photoGalleryView.isHidden = false
        } else {
            photoHeightConstraint.constant = 0.0
            photoGalleryView.isHidden = true
        }

        photoGalleryView.loadData(imageList: tweetModel.photoURL ?? [],
                                  hideDeleteButton: hideDeleteButton)
    }

    //MARK: - Action Methods -
    @IBAction func deleteTweet(_ sender: Any) {
        deleteTweetCallBack?(tweetModel)
    }
}
