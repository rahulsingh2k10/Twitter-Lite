//
//  RoundedButton.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import UIKit


@IBDesignable
class RoundedButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
    }
}
