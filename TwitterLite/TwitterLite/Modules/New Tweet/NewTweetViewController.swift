//
//  NewTweetViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 30/06/22.
//

import UIKit
import YPImagePicker


protocol NewTweetDelegate: AnyObject {
    func didFinishTweet()
}


class NewTweetViewController: BaseViewController<NewTweetViewModel> {
    override var desiredHeight: CGFloat {
        return 450.0
    }

    public weak var newTweetDelegate: NewTweetDelegate?

    @IBOutlet weak private var placeholderTextView: PlaceholderTextView!
    @IBOutlet weak private var ringProgressView: RingProgressView!
    @IBOutlet weak private var photoGalleryView: PhotoGalleryView!
    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var tweetButton: UIButton!

    lazy private var picker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        config.usesFrontCamera = true
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = YPPickerScreen.library
        config.hidesStatusBar = false

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
            self.photoGalleryView.loadData(imageList: photos)
            self.tweetButton.isEnabled = viewModel?.shouldEnableSendingTweet() ?? false

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
        view.endEditing(true)

        activityView.startAnimating(title: StringValue.posting.rawValue)

        viewModel?.addTweet() {[weak self] error in
            guard let strongSelf = self else { return }

            if let error = error {
                strongSelf.presentAlert(message: error.localizedDescription)
            } else {
                strongSelf.newTweetDelegate?.didFinishTweet()
                strongSelf.dismiss(animated: true)
            }
        }
    }

    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func showImagePicker(_ sender: UIButton) {
        present(picker, animated: true)
    }

    // MARK: - Private Methods -
    private func setupUI() {
        tweetButton.isEnabled = viewModel?.shouldEnableSendingTweet() ?? false

        profileView.setupUI()

        placeholderTextView.textViewDelegate = self

        ringProgressView.animateCircle(toValue: 0)

        photoGalleryView.didRemoveItem = {[unowned self] item in
            if let index = self.viewModel?.tweetModel.photos?.firstIndex (where: { $0.image == (item as! ImageWrapper).image }) {
                self.viewModel?.tweetModel.photos?.remove(at: index)
                self.tweetButton.isEnabled = viewModel?.shouldEnableSendingTweet() ?? false
            }
        }
    }
}


extension NewTweetViewController: PlaceholderTextViewDelegate {
    func placeholderTextViewDidChangeText(_ text: String) {
        let toValue: CGFloat = CGFloat(text.count)/CGFloat(Utils.maxCharacter)
        ringProgressView.animateCircle(toValue: toValue)

        viewModel?.tweetModel.caption = text
        tweetButton.isEnabled = viewModel?.shouldEnableSendingTweet() ?? false
    }

    func placeholderTextViewShouldReplace(_ text: String) -> Bool {
        if(text.count > 0 &&
           ( text == "\n" || placeholderTextView.text.count > Utils.maxCharacter - 2)) {
            return false
        } else {
            return true
        }
    }
}
