//
//  RoundedButton.swift
//  TwitterLite
//
//  Created by Rahul Singh on 02/07/22.
//

import UIKit


@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
