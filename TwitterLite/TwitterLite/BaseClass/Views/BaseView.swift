//
//  BaseView.swift
//  TwitterLite
//
//  Created by Rahul Singh on 24/06/22.
//

import UIKit


class BaseView: UIView, NibOwnerLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.loadNibContent()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.loadNibContent()
    }
}
