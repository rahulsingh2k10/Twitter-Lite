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

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        layer.cornerRadius = bounds.size.width/2
        layer.masksToBounds = true
    }

    public var mode: Mode = .view {
        didSet {
            if mode == .add {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
                addGestureRecognizer(tapGesture)
            }
        }
    }

    @IBOutlet weak private var theImageView: UIImageView!

    // MARK: - Public Methods -
    public func getImage() -> UIImage? {
        return theImageView.image
    }

    public func load(image: UIImage?) {
        theImageView.image = image
    }

    public func loadImage(url: URL?) {
        theImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "Placeholder"))
    }

    // MARK: - Gesture Recognizer Methods -
    @objc
    private func tap(gesture: UITapGestureRecognizer) {
        didTapProfileView?()
    }
}
