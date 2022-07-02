//
//  NewTweetViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 30/06/22.
//

import UIKit
import YPImagePicker


class NewTweetViewController: BaseViewController<NewTweetViewModel> {
    override var desiredHeight: CGFloat {
        return 450.0
    }

    @IBOutlet weak private var placeholderTextView: PlaceholderTextView!
    @IBOutlet weak private var ringProgressView: RingProgressView!
    @IBOutlet weak private var photoGalaryView: PhotoGalaryView!
    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var tweetButton: UIButton!

    lazy private var picker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        config.usesFrontCamera = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = YPPickerScreen.library

        config.library.defaultMultipleSelection = true
        config.library.maxNumberOfItems = 4

        picker = YPImagePicker(configuration: config)
        picker.didFinishPicking {[unowned picker, unowned self] (items, cancelled) in
            var photos: [ImageWrapper] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    let imageWrapper = ImageWrapper(image: photo.image)
                    photos.append(imageWrapper)
                default: break
                }
            }

            self.viewModel?.tweetModel.photos = photos
            self.photoGalaryView.loadData(imageList: photos)
            self.enableDisableTweetButton()
            
            picker.dismiss(animated: true)
        }

        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        placeholderTextView.becomeFirstResponder()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        profileView.loadImage(url: Utils.shared.loggedInUser?.photoURL)
    }

    // MARK: - Action Methods -
    @IBAction func tweetButtonClicked(_ sender: Any) {
        let data = try? JSONEncoder().encode(viewModel?.tweetModel)
        let jsonDict = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]

        print(jsonDict)
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        present(picker, animated: true)
    }

    // MARK: - Private Methods -
    private func enableDisableTweetButton() {
        let isTextAvailable = ((viewModel?.tweetModel.caption?.count ?? 0) > 0)
        let isPhotosAvailable = ((viewModel?.tweetModel.photos?.count ?? 0) >= 1)

        tweetButton.isEnabled = (isTextAvailable || isPhotosAvailable)
    }

    private func setupUI() {
        enableDisableTweetButton()

        profileView.setupUI()

        placeholderTextView.textViewDelegate = self

        ringProgressView.animateCircle(toValue: 0)

        photoGalaryView.didRemoveItem = {[unowned self] item in
            if let index = self.viewModel?.tweetModel.photos?.firstIndex (where: { $0.image == (item as! ImageWrapper).image }) {
                self.viewModel?.tweetModel.photos?.remove(at: index)
                self.enableDisableTweetButton()
            }
        }
    }
}


extension NewTweetViewController: PlaceholderTextViewDelegate {
    func placeholderTextViewDidChangeText(_ text: String) {
        let toValue: CGFloat = CGFloat(text.count)/CGFloat(Constants.maxCharacter)
        ringProgressView.animateCircle(toValue: toValue)
        
        viewModel?.tweetModel.caption = text
        enableDisableTweetButton()
    }
    
    func placeholderTextViewShouldReplace(_ text: String) -> Bool {
        if(text.count > 0 &&
           ( text == "\n" || placeholderTextView.text.count > Constants.maxCharacter)) {
            return false
        } else {
            return true
        }
    }
}
