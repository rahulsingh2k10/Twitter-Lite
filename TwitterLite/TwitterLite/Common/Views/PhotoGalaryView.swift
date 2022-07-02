//
//  PhotoGalaryView.swift
//  TwitterLite
//
//  Created by Rahul Singh on 01/07/22.
//

import UIKit


@IBDesignable
class PhotoGalaryView: BaseView {
    public var didRemoveItem: ((Any) -> ())?

    @IBInspectable var viewSize: CGFloat = 0.0

    @IBOutlet weak private var photoCollectionView: UICollectionView!

    private var imageList: [Any]?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        photoCollectionView.register(cell: PhotoFrameCollectionViewCell.self)
    }

    public func loadData(imageList: [Any]) {
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


extension PhotoGalaryView: UICollectionViewDataSource {
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
        cell.loadImage(imageData: imageList![indexPath.row])
        cell.deleteButtonCallback = {[unowned self] passedCell in
            self.deleteItem(cell: passedCell)
        }

        return cell
    }
}


extension PhotoGalaryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: viewSize - 20, height: viewSize - 20)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
}
