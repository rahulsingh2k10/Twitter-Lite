//
//  PhotoGalleryView.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import UIKit


@IBDesignable
class PhotoGalleryView: BaseView {
    public var didRemoveItem: ((Any) -> ())?

    @IBOutlet weak private var photoCollectionView: UICollectionView!

    private var imageList: [Any]?
    private var hideDeleteButton: Bool = false

    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 10, bottom: 10.0, right: 0.0)

    public func loadData(imageList: [Any], hideDeleteButton: Bool = false) {
        photoCollectionView.register(cell: PhotoFrameCollectionViewCell.self)

        self.hideDeleteButton = hideDeleteButton
        self.imageList = imageList

        photoCollectionView.reloadData()
    }

    private func deleteItem(cell: UICollectionViewCell) {
        if let indexPath = photoCollectionView.indexPath(for: cell) {
            didRemoveItem?(imageList![indexPath.row])

            imageList?.remove(at: indexPath.row)

            photoCollectionView.reloadData()
        }
    }
}


extension PhotoGalleryView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(reusableCell: PhotoFrameCollectionViewCell.self,
                                          for: indexPath)
        cell.loadImage(imageData: imageList![indexPath.row], hideDeleteButton: hideDeleteButton)
        cell.deleteButtonCallback = {[unowned self] passedCell in
            self.deleteItem(cell: passedCell)
        }

        return cell
    }
}


extension PhotoGalleryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height - 10, height: frame.height - 10)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
