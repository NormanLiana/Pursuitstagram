//
//  PursuitstagramTBController.swift
//  Pursuitstagram-Project
//
//  Created by Liana Norman on 11/25/19.
//  Copyright © 2019 Liana Norman. All rights reserved.
//

import UIKit

class PursuitstagramTBController: UITabBarController {

    lazy var feedVC = UINavigationController(rootViewController: FeedVC())
    
    lazy var profileVC: UINavigationController = {
        let userProfileVC = ProfileVC()
        userProfileVC.user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        userProfileVC.isCurrentUser = true
        return UINavigationController(rootViewController: userProfileVC)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedVC.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "list.dash"), tag: 0)
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.square"), tag: 1)
        self.viewControllers = [feedVC, profileVC]
    }
}
