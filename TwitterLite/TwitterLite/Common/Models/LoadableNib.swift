//
//  LoadableNib.swift
//  TwitterLite
//
//  Created by Rahul Singh on 24/06/22.
//

import UIKit


public protocol NibLoadable: AnyObject {
    static var nib: UINib { get }
}


public extension NibLoadable {
    static var nib: UINib {
        let nibName = String(describing: self)
        let bundle = Bundle(for: self)

        return UINib(nibName: nibName, bundle: bundle)
    }
}


public extension NibLoadable where Self: UIView {
    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: .none, options: .none).first as? Self else {
            fatalError("The nib \(nib) expected to be of type: \(self)")
        }

        return view
    }
}


public protocol Reusable: AnyObject {
    static var identifier: String { get }
}


public extension Reusable {
    static var identifier: String {
        let name = String(describing: self)
        let fileName = name.components(separatedBy: ".").last!

        return fileName
    }
}


public typealias NibReusable = Reusable & NibLoadable


public protocol NibOwnerLoadable: AnyObject {
    static var nib: UINib { get }
}


public extension NibOwnerLoadable {
    static var nib: UINib {
        let name = String(describing: self)
        let fileName = name.components(separatedBy: ".").last!.components(separatedBy: "<").first!

        return UINib(nibName: fileName, bundle: Bundle(for: self))
    }
}


public extension NibOwnerLoadable where Self: UIView {
    func loadNibContent() {
        let layoutAttributes: [NSLayoutConstraint.Attribute] = [.top, .leading, .bottom, .trailing]
        let views = type(of: self).nib.instantiate(withOwner: self, options: .none)

        for case let view as UIView in views {
            view.translatesAutoresizingMaskIntoConstraints = false

            addSubview(view)

            NSLayoutConstraint.activate(layoutAttributes.map { attribute in
                NSLayoutConstraint(item: view,
                                   attribute: attribute,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: attribute,
                                   multiplier: 1.0,
                                   constant: 0.0)
            })
        }
    }
}
