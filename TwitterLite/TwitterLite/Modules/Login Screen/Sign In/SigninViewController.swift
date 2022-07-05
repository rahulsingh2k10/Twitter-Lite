//
//  SigninViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 27/06/22.
//

import UIKit


class SigninViewController: BaseViewController<SigninViewModel> {
    override var desiredHeight: CGFloat {
        return 450.0
    }

    @IBOutlet weak private var signinButton: UIButton!
    @IBOutlet weak private var emailAddressTextField: UITextField!

    public weak var loginDelegate: LoginDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        enableDisableSignInButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailAddressTextField.becomeFirstResponder()
    }

    // MARK: - Action Methods -
    @IBAction private func textFieldChanged(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            viewModel?.userModel.emailAddress = sender.text
        case 1:
            viewModel?.userModel.password = sender.text
        default: break
        }

        enableDisableSignInButton()
    }

    @IBAction private func signinButtonClicked(_ sender: UIButton?) {
        view.endEditing(true)
        activityView.startAnimating(title: StringValue.signingIn.rawValue)

        viewModel?.signInUser() { [weak self]user, error in
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
    }

    // MARK: - Private Methods -
    @discardableResult
    private func enableDisableSignInButton()  -> Bool {
        var shouldEnable = false

        if let vm = viewModel, vm.isModelValid() {
            shouldEnable = true
        } else {
            shouldEnable = false
        }

        signinButton.isEnabled = shouldEnable

        return shouldEnable
    }
}


extension SigninViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFieldTag = textField.tag

        if textField.tag <= 0 {
            let textFields: [UITextField] = getAllSubviews(fromView: view)
            if let nextTextField = textFields.filter({ $0.tag == (textFieldTag + 1)}).first {
                nextTextField.becomeFirstResponder()
            }

            return true
        } else {
            if enableDisableSignInButton() {
                signinButtonClicked(.none)
            }

            return enableDisableSignInButton()
        }
    }
}
