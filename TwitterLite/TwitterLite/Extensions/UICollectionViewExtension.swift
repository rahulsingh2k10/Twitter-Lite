//
//  UICollectionViewExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import Foundation
import UIKit


extension UICollectionView {
    public func register<T: UICollectionViewCell>(cell: T.Type) where T: Reusable & NibLoadable {
        let bundle = Bundle(for: cell)
        let nib = UINib(nibName: cell.identifier, bundle: bundle)

        register(nib, forCellWithReuseIdentifier: cell.identifier)
    }

    public func dequeue<T: UICollectionViewCell>(reusableCell: T.Type,
                                                 for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: reusableCell.identifier,
                                             for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(reusableCell.identifier) matching type \(reusableCell.self).")
        }

        return cell
    }
}
