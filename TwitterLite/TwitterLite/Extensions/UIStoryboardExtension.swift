//
//  UIStoryboardExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 24/06/22.
//

import UIKit


extension UIStoryboard {
    public enum StoryBoardName: String {
        case Login
        case Main
        case LaunchScreen
    }

    public convenience init(name: StoryBoardName) {
        self.init(name: name.rawValue, bundle: .none)
    }

    public func viewController(type: UIViewController.Type) -> UIViewController {
        let className = type.description().components(separatedBy: ".").last!

        return instantiateViewController(identifier: className)
    }
}
