//
//  RoutesListViewController.swift
//  Pace
//
//  Created by Ang Wei Neng on 25/3/19.
//  Copyright © 2019 nus.cs3217.pace. All rights reserved.
//

import UIKit

class RoutesListViewController: UIViewController {
    // MARK: - Properties
    private let feedIdentifier = "friendsFeedCell"
    private var friendsRoutes: [String] = []
    private(set) var friends: [String] = []
    @IBOutlet private weak var friendsTable: UICollectionView!
    private let itemsPerRow = 1
    private let sectionInsets = UIEdgeInsets(top: 0,
                                             left: 20.0,
                                             bottom: 100.0,
                                             right: 20.0)

    // TODO: Replace with reactive/observer pattern, probably when we have rxswift up.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /*
        if UserManager.isLoggedIn {
            /*
             UserManager.getCurrentUser { user in
             print(user == nil)
             if let _ = user {
             self.friends = ["Ben", "YK", "YYC"]
             } else {
             self.friends = []
             }
             self.friendsTable.reloadData()
             }*/
            UserManager.getFriends { [weak self] names, error in
                guard error == nil, let names = names else {
                    self?.friends = ["no friends"]
                    return
                }
                self?.friends = names
                self?.friendsRoutes = names // TODO: Remove and replace with actual routes
                self?.friendsTable.reloadData()
            }
        } else {
            // We need to set the following to empty array as user might log out of the app, and
            // that friends, friendsRoutes isn't empty.
            self.friends = []
            self.friendsRoutes = []
            let alert = UIAlertController(
                title: "Not logged in",
                message: "You are not logged in yet. Please sign in to view routes created by your friends.",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
 */
    }
}

// MARK: - UICollectionViewDataSource
extension RoutesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    // Tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendsRoutes.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: feedIdentifier, for: indexPath) as! FriendsFeedCollectionViewCell
        if indexPath.item < friends.count {
            cell.friend = friends[indexPath.item]
        }
        cell.backgroundColor = .blue
        // Configure the cell
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension RoutesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * CGFloat(itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(itemsPerRow)

        return CGSize(width: widthPerItem, height: widthPerItem)
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
