//
//  HomeViewController.swift
//  TwitterLite
//
//  Created by Rahul Singh on 26/06/22.
//

import UIKit


class HomeViewController: BaseViewController<HomeViewModel> {
    @IBOutlet weak private var profileView: ProfileView!
    @IBOutlet weak private var newTweetButton: UIButton!
    @IBOutlet weak private var tweetsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        newTweetButton.isHidden = true

        profileView.setupUI()

        tweetsTableView.register(cell: TweetsTableViewCell.self)

        activityView.startAnimating()
        if FirebaseManager.shared.currentUser() == .none {
            activityView.stopAnimating()

            openLoginViewController()
        } else {
            fetchTweets()
            fetchLoggedInUserDetails()
        }
    }

    // MARK: - Action Methods -
    @IBAction func newTweetClicked(_ sender: Any) {
        let newTweetVC = UIStoryboard(name: .Main).viewController(type: NewTweetViewController.self) as! NewTweetViewController
        newTweetVC.newTweetDelegate = self
        newTweetVC.modalPresentationStyle = .fullScreen

        present(newTweetVC, animated: true)
    }

    @IBAction private func signOutButtonClicked(_ sender: Any) {
        let yesAction = UIAlertAction(title: StringValue.yesTitle.rawValue,
                                      style: .default) { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.activityView.startAnimating(title: StringValue.signingOut.rawValue)

            FirebaseManager.shared.signOut() { [weak self] error in
                guard let strongSelf = self else { return }

                strongSelf.activityView.stopAnimating()

                strongSelf.openLoginViewController(true)
            }
        }

        let cancelAction = UIAlertAction(title: StringValue.cancelTitle.rawValue,
                                         style: .default,
                                         handler: .none)

        presentAlert(message: StringValue.signOutConfirmation.rawValue,
                     alertAction: [yesAction, cancelAction])
    }

    // MARK: - Private Methods -
    private func fetchTweets() {
        if viewModel?.lastCreatedDateTimeStamp == .none {
            activityView.startAnimating()
        }

        viewModel?.fetchTweets() {[weak self] (tweets, error) in
            guard let strongSelf = self else { return }

            strongSelf.activityView.stopAnimating()

            if let tweets = tweets,
               let vm = strongSelf.viewModel,
               tweets.count > 0 {
                if let _ = vm.lastCreatedDateTimeStamp {
                    let count = vm.tweetList.count

                    vm.tweetList.insert(contentsOf: tweets, at: count)

                    let indexpaths = tweets.enumerated().compactMap {  (index, _) in
                        return IndexPath(row: count + index, section: 0)
                    }

                    strongSelf.tweetsTableView.beginUpdates()
                    strongSelf.tweetsTableView.insertRows(at: indexpaths, with: .none)
                    strongSelf.tweetsTableView.endUpdates()
                } else {
                    vm.tweetList.append(contentsOf: tweets)

                    strongSelf.tweetsTableView.reloadData()
                }

                vm.lastCreatedDateTimeStamp = vm.tweetList.last?.createdTimeStamp
            }
        }
    }

    private func fetchLoggedInUserDetails() {
        FirebaseDatabaseManager.shared.fetchLoggedInUserDetails() { [weak self] error in
            guard let strongSelf = self else { return }

            strongSelf.profileView.loadImage(url: Utils.shared.loggedInUser?.photoURL)
            strongSelf.newTweetButton.isHidden = false
        }
    }

    private func openLoginViewController(_ animated: Bool = false) {
        DispatchQueue.main.async() {[weak self] in
            guard let strongSelf = self else { return }

            let loginVC = UIStoryboard(name: .Login).viewController(type: LoginViewController.self) as! LoginViewController
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.loginDelegate = self

            strongSelf.present(loginVC, animated: animated)
        }
    }
}

extension HomeViewController: LoginDelegate {
    func loginDidComplete() {
        fetchTweets()
        fetchLoggedInUserDetails()
    }
}


extension HomeViewController:  NewTweetDelegate {
    func didFinishTweet() {
        fetchTweets()
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tweetList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusableCell: TweetsTableViewCell.self, for: indexPath)

        if let tweet = viewModel?.tweetList[indexPath.row] {
            cell.loadData(tweetModel: tweet)
        }

        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel?.shouldFetchData(index: Double(indexPath.row)) ?? false {
            fetchTweets()
        }
    }
}
