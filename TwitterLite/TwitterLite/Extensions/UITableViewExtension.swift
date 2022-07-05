//
//  UITableViewExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import UIKit


extension UITableView {
    public func register<T: UITableViewCell>(cell: T.Type) where T: Reusable & NibLoadable {
        let bundle = Bundle(for: cell)
        let nib = UINib(nibName: cell.identifier, bundle: bundle)

        register(nib, forCellReuseIdentifier: cell.identifier)
    }

    public func dequeue<T: UITableViewCell>(reusableCell: T.Type,
                                            for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: reusableCell.identifier,
                                             for: indexPath) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(reusableCell.identifier) matching type \(reusableCell.self).")
        }

        return cell
    }
}
