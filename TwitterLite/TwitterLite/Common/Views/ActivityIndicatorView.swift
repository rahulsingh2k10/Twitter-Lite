//
//  ActivityIndicatorView.swift
//  TwitterLite
//
//  Created by Rahul Singh on 28/06/22.
//

import UIKit
import NVActivityIndicatorView


class ActivityIndicatorView: BaseView {
    @IBOutlet weak private var activityLabel: UILabel!
    @IBOutlet weak private var activityView: NVActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        activityView.type = .lineScale
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = .systemBlue
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.2

        insertSubview(blurEffectView, at: 0)
    }

    // MARK: - Public Methods -
    public func startAnimating(title: String = StringValue.loading.rawValue) {
        isHidden = false

        activityLabel.text = title
        activityView.startAnimating()
    }

    public func stopAnimating() {
        isHidden = true

        activityView.stopAnimating()
    }
}
