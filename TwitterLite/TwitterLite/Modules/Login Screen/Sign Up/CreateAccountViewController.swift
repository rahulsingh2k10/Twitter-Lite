//
//  CreateAccountViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import UIKit


class CreateAccountViewController: BaseViewController<CreateAccountViewModel> {
    override var desiredHeight: CGFloat {
        return 750.0
    }

    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var profileView: ProfileView!

    public weak var loginDelegate: LoginDelegate?

    // TODO: Replace UIImagePickerController To YPImagePicker
    lazy private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.setupUI(mode: .add)
        profileView.load(image: UIImage(systemName: "plus"))
        profileView.didTapProfileView = {[unowned self] in
            self.imageButtonClicked()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        nameTextField.becomeFirstResponder()
    }

    // MARK: - Action Methods -
    @IBAction private func textFieldChanged(_ sender: UITextField) {
        if let loginField = LoginField(rawValue: sender.tag) {
            switch loginField {
            case .displayName:
                viewModel?.userModel.displayName = sender.text
            case .emailAddress:
                viewModel?.userModel.emailAddress = sender.text
            case .userName:
                viewModel?.userModel.userName = sender.text
            case .password:
                viewModel?.userModel.password = sender.text
            default: break
            }
        }
    }

    @IBAction private func createAccountClicked(_ sender: Any?) {
        do {
            try viewModel?.validateCreateUserModel()

            view.endEditing(true)

            activityView.startAnimating(title: StringValue.signingIn.rawValue)

            viewModel?.createUser() { [weak self] (user, error) in
                guard let strongSelf = self else { return }

                strongSelf.activityView.stopAnimating()

                if let error = error {
                    strongSelf.presentAlert(message: error.localizedDescription)
                } else if let user = user {
                    Utils.shared.loggedInUser = user
                    strongSelf.loginDelegate?.loginDidComplete()
                    strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true)
                }
            }
        } catch (let error as LoginError) {
            presentAlert(message: error.errorDescription)
        } catch {
            presentAlert(message: error.localizedDescription)
        }
    }

    // MARK: - Private Methods -
    private func imageButtonClicked() {
        view.endEditing(true)

        let alertVC = UIAlertController(title: StringValue.pickPhoto.rawValue,
                                        message: StringValue.choosePicture.rawValue,
                                        preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: StringValue.library.rawValue,
                                          style: .default) { [unowned self] action in
            let libraryImagePicker = self.imagePicker (sourceType: .photoLibrary)

            self.present(libraryImagePicker, animated: true)
        }

        let cameraAction = UIAlertAction(title: StringValue.camera.rawValue,
                                         style: .default) { [unowned self] (action) in
            let cameraImagePicker = self.imagePicker (sourceType: .camera)

            self.present(cameraImagePicker, animated: true)
        }

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertVC.addAction(cameraAction)
        }

        alertVC.addAction(libraryAction)
        alertVC.addAction(.cancelAction)

        if let popoverPresentationController = alertVC.popoverPresentationController {
            popoverPresentationController.sourceView = profileView
            popoverPresentationController.sourceRect = profileView.bounds
        }

        present(alertVC, animated: true)
    }

    private func imagePicker (sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self

        return imagePicker
    }
}


extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }

        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }

        viewModel?.userModel.photoURL = imageURL
        profileView.loadImage(url: imageURL)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldTag = textField.tag

        if textField.tag <= 2 {
            let textFields: [UITextField] = getAllSubviews(fromView: view)
            if let nextTextField = textFields.filter({ $0.tag == (textFieldTag + 1)}).first {
                // TODO: Scroll View above Keyboard
                nextTextField.becomeFirstResponder()
            }
        } else {
            createAccountClicked(.none)
        }

        return true
    }
}
