//
//  ProfileView.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import UIKit
import SDWebImage


@IBDesignable
class ProfileView: BaseView {
    public var didTapProfileView: (() -> ())?

    @IBInspectable var borderWidth: CGFloat = 8
    @IBInspectable var borderColor: UIColor = .systemBlue

    @IBOutlet weak private var theImageView: UIImageView!
    @IBOutlet private var imageViewConstraint: [NSLayoutConstraint]!

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor

        imageViewConstraint.forEach { constraint in
            constraint.constant = bounds.width/4
        }
    }

    public var mode: Mode = .view {
        didSet {
            if mode == .add {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
                addGestureRecognizer(tapGesture)
            }
        }
    }

    // MARK: - Public Methods -
    public func getImage() -> UIImage? {
        return theImageView.image
    }

    public func load(image: UIImage?) {
        imageViewConstraint.forEach { constraint in
            constraint.constant = 0
        }
        theImageView.image = image
    }

    public func loadImage(url: URL?) {
        theImageView.sd_setImage(with: url,
                                 placeholderImage: UIImage(named: "Placeholder"),
                                 options: .highPriority) {[weak self] (image, error, cacheType, url) in
            guard let strongSelf = self else { return }

            strongSelf.imageViewConstraint.forEach { constraint in
                constraint.constant = 0
            }
        }
    }

    // MARK: - Gesture Recognizer Methods -
    @objc
    private func tap(gesture: UITapGestureRecognizer) {
        didTapProfileView?()
    }
}
