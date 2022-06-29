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
    @IBOutlet weak private var createAccountButton: UIButton!

    public weak var loginDelegate: LoginDelegate?

    lazy private var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        createAccountButton.isEnabled = false

        profileView.mode = .add
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
        switch sender.tag {
        case 0:
            viewModel?.userModel.displayName = sender.text
        case 1:
            viewModel?.userModel.emailAddress = sender.text
        case 2:
            viewModel?.userModel.userName = sender.text
        case 3:
            viewModel?.userModel.password = sender.text
        default: break
        }

        enableDisableCreateButton()
    }

    @IBAction private func createAccountClicked(_ sender: Any?) {
        view.endEditing(true)
        activityView.startAnimating(title: StringValue.signingIn.rawValue)

        viewModel?.createUser() { [weak self] (user, error) in
            guard let strongSelf = self else { return }

            strongSelf.activityView.stopAnimating()

            if let error = error {
                let okAction = (UIAlertAction(title: StringValue.okTitle.rawValue,
                                              style: .default,
                                              handler: .none))

                strongSelf.presentAlert(message: error.localizedDescription, alertAction: [okAction])
            } else if let user = user {
                Utils.shared.loggedInUser = user
                strongSelf.loginDelegate?.loginDidComplete()
                strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true)
            }
        }
    }

    // MARK: - Private Methods -
    @discardableResult
    private func enableDisableCreateButton()  -> Bool {
        var shouldEnable = false

        if let vm = viewModel, vm.isModelValid() {
            shouldEnable = true
        } else {
            shouldEnable = false
        }

        createAccountButton.isEnabled = shouldEnable

        return shouldEnable
    }

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

        let cancelAction = UIAlertAction(title: StringValue.cancelTitle.rawValue, style: .cancel)

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertVC.addAction(cameraAction)
        }

        alertVC.addAction(libraryAction)
        alertVC.addAction(cancelAction)

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

        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }

        guard let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }

        viewModel?.userModel.photoURL = imageURL
        profileView.load(image: image)
        enableDisableCreateButton()
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

            return true
        } else {
            if enableDisableCreateButton() {
                createAccountClicked(.none)
            }

            return enableDisableCreateButton()
        }
    }
}
