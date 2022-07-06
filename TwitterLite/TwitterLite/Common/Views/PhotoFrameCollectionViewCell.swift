//
//  PhotoFrameCollectionViewCell.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import UIKit
import SDWebImage


@IBDesignable
class PhotoFrameCollectionViewCell: UICollectionViewCell, NibReusable {
    public var deleteButtonCallback: ((UICollectionViewCell) -> ())?

    @IBInspectable var borderWidth: CGFloat = 1.0
    @IBInspectable var cornerRadius: CGFloat = 8.0
    @IBInspectable var borderColor: UIColor = .placeholderText

    @IBOutlet weak private var deleteButton: UIButton!
    @IBOutlet weak private var photoImageView: UIImageView!

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }

    //MARK: - Public Methods -
    public func loadImage(imageData: Any, hideDeleteButton: Bool = false) {
        deleteButton.isHidden = hideDeleteButton

        if imageData is ImageWrapper {
            photoImageView.image = (imageData as? ImageWrapper)?.image
        } else {
            if let urlString = imageData as? String,
               let url = URL(string: urlString) {
                photoImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
                photoImageView.sd_setImage(with: url,
                                           placeholderImage: UIImage(systemName: "Placeholder"))
            } else {
                photoImageView.image = UIImage(systemName: "Placeholder")
            }
        }
    }

    // MARK: - Action Methods -
    @IBAction private func deleteButtonClicked(_ sender: Any) {
        deleteButtonCallback?(self)
    }
}
