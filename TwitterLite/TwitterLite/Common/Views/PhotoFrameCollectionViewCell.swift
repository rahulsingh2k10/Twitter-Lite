//
//  PhotoFrameCollectionViewCell.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import UIKit


class PhotoFrameCollectionViewCell: UICollectionViewCell, NibReusable {
    public var deleteButtonCallback: ((UICollectionViewCell) -> ())?

    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var photoImageView: UIImageView!

    //MARK: - Public Methods -
    public func loadImage(imageData: Any) {
        if imageData is ImageWrapper {
            photoImageView.image = (imageData as? ImageWrapper)?.image
        } else {
            photoImageView.sd_setImage(with: imageData as? URL,
                                       placeholderImage: UIImage(systemName: "Placeholder"))
        }
    }

    // MARK: - Action Methods -
    @IBAction private func deleteButtonClicked(_ sender: Any) {
        deleteButtonCallback?(self)
    }
}
