//
//  UIViewControllerExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import UIKit


extension UIViewController {
    func getAllSubviews<T: UIView>(fromView view: UIView)-> [T] {
        return view.subviews.map { (view) -> [T] in
            if let view = view as? T {
                return [view]
            } else {
                return getAllSubviews(fromView: view)
            }
        }.flatMap({$0})
    }
}
