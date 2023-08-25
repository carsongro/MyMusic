//
//  MMFeedViewController.swift
//  MyMusic
//
//  Created by Carson Gross on 8/23/23.
//

import UIKit

/// Controller for the primary feed
class MMFeedViewController: UIViewController {
    
    // MARK: Properties
    
    let feedView = MMFeedView()
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        setUpView()
    }
    
    // MARK: Private
    
    private func setUpView() {
        view.addSubview(feedView)
        NSLayoutConstraint.activate([
            feedView.topAnchor.constraint(equalTo: view.topAnchor),
            feedView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            feedView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            feedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
