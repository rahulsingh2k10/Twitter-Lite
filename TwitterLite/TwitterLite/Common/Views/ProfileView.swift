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

    private var mode: Mode = .view

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    // MARK: - Public Methods -
    public func setupUI(mode: Mode = .view) {
        self.mode = mode

        setImageViewConstraints(constant: bounds.width/4)

        if mode == .add {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
            addGestureRecognizer(tapGesture)
        }
    }

    public func getImage() -> UIImage? {
        return theImageView.image
    }

    public func load(image: UIImage?) {
        theImageView.image = image
    }

    public func loadImage(url: URL?) {
        setImageViewConstraints(constant: bounds.width/4)

        theImageView.sd_setImage(with: url,
                                 placeholderImage: UIImage(systemName: "photo"),
                                 options: .highPriority) {[weak self] (image, error, cacheType, url) in
            guard let strongSelf = self else { return }

            strongSelf.setImageViewConstraints()
        }
    }

    // MARK: - Private Methods -
    private func setImageViewConstraints(constant: CGFloat = 0.0) {
        imageViewConstraint.forEach { constraint in
            constraint.constant = constant
        }
    }

    // MARK: - Gesture Recognizer Methods -
    @objc
    private func tap(gesture: UITapGestureRecognizer) {
        didTapProfileView?()
    }
}
