//
//  MMTabBarViewController.swift
//  MyMusic
//
//  Created by Carson Gross on 8/23/23.
//

import UIKit

/// Main tab bar for the app
class MMTabBarViewController: UITabBarController {
    
    // MARK: Init

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    // MARK: Private
    
    private func setUpTabs() {
        let feedVC = MMFeedViewController()
        let profileVC = MMProfileViewController()
        
        profileVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: feedVC)
        let nav2 = UINavigationController(rootViewController: profileVC)
        
        nav1.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "music.note.house"),
            selectedImage: UIImage(systemName: "music.note.house.fill")
        )
        
        nav2.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBar.tintColor = .label
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setViewControllers([nav1, nav2],
                           animated: true)
    }
}
