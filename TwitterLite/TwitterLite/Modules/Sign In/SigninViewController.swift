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

    override func viewDidLoad() {
        super.viewDidLoad()

        signinButton.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailAddressTextField.becomeFirstResponder()
    }

    // MARK - Action Methods -
    @IBAction func textFieldChanged(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            viewModel?.model.emailAddress = sender.text
        case 1:
            viewModel?.model.password = sender.text
        default: break
        }

        if let vm = viewModel, vm.isModelValid() {
            signinButton.isEnabled = true
        } else {
            signinButton.isEnabled = false
        }
    }

    @IBAction func signinButtonClicked(_ sender: Any) {
        activityView.startAnimating()
        viewModel?.signInUser() { [weak self]user, error in
            guard let strongSelf = self else { return }

            strongSelf.activityView.stopAnimating()

            if let error = error {
                let okAction = (UIAlertAction(title: StringValue.okTitle.rawValue,
                                              style: .default,
                                              handler: .none))

                strongSelf.presentAlert(message: error.localizedDescription, alertAction: [okAction])
            } else if let user = user {
                Utils.shared.loggedInUser = user
                strongSelf.presentingViewController?.presentingViewController?.dismiss(animated: true)
            }
        }
    }
}
