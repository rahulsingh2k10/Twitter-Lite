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

    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        newTweetButton.isHidden = true

        profileView.setupUI()

        configureTableView()

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

            strongSelf.viewModel?.signOutUser() { [weak self] error in
                guard let strongSelf = self else { return }

                strongSelf.activityView.stopAnimating()

                strongSelf.openLoginViewController(true)
            }
        }

        presentAlert(message: StringValue.signOutConfirmation.rawValue,
                     alertAction: [yesAction, .cancelAction])
    }

    @objc
    func refresh(_ sender: AnyObject?) {
        viewModel?.fetchLatestTweets() { [weak self] tweets, error in
            guard let strongSelf = self else { return }

            strongSelf.refreshControl.endRefreshing()

            if let vm = strongSelf.viewModel,
               let tweets = tweets, tweets.count > 0 {
                vm.tweetList.insert(contentsOf: tweets, at: 0)

                let indexpaths = (0 ..< tweets.count).compactMap { IndexPath(row: $0, section: 0) }

                strongSelf.tweetsTableView.beginUpdates()
                strongSelf.tweetsTableView.insertRows(at: indexpaths, with: .none)
                strongSelf.tweetsTableView.endUpdates()
            }
        }
    }

    // MARK: - Private Methods -
    private func configureTableView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)

        tweetsTableView.register(cell: TweetsTableViewCell.self)
        tweetsTableView.addSubview(refreshControl)
    }

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
        viewModel?.getloggedInUserDetail() {[weak self] error in
            guard let strongSelf = self else { return }

            if let error = error {
                strongSelf.presentAlert(message: error.localizedDescription)
            } else {
                strongSelf.profileView.loadImage(url: Utils.shared.loggedInUser?.photoURL)
                strongSelf.newTweetButton.isHidden = false
            }
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
        refresh(.none)
    }
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.tweetList.count ?? 0
    }

    private func delete(tweetModel: ViewTweetModel) {
        activityView.startAnimating()

        viewModel?.delete(tweetModel: tweetModel, callBackHandler: {[weak self] error in
            guard let strongSelf = self else { return }

            strongSelf.activityView.stopAnimating()

            if let error = error as? FireBaseError {
                strongSelf.presentAlert(message: error.errorDescription ?? String())
            } else if let error = error {
                strongSelf.presentAlert(message: error.localizedDescription)
            } else {
                if let index = strongSelf.viewModel?.tweetList.firstIndex(where: { $0.tweetID == tweetModel.tweetID }) {
                    strongSelf.viewModel?.tweetList.remove(at: index)

                    strongSelf.tweetsTableView.beginUpdates()
                    strongSelf.tweetsTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    strongSelf.tweetsTableView.endUpdates()

                }
            }
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(reusableCell: TweetsTableViewCell.self, for: indexPath)

        cell.deleteTweetCallBack = {[unowned self] tweetModel in
            self.delete(tweetModel: tweetModel)
        }

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
