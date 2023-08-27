//
//  MMMusicAuthViewController.swift
//  MyMusic
//
//  Created by Carson Gross on 8/26/23.
//

import SwiftUI
import MusicKit

/// Controller for the user profile and settings
class MMMusicAuthViewController: UIViewController {
    
    // MARK: Properties
    
    private var profileSwiftUIController: UIHostingController<MMAuthView>?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSwiftUIController()
    }
    
    // MARK: Private
    
    private func addSwiftUIController() {
        let profileSwiftUIController = UIHostingController(
            rootView: MMAuthView { [weak self] in
                self?.handleAuthTap()
            }
        )
        
        addChild(profileSwiftUIController)
        profileSwiftUIController.didMove(toParent: self)
        
        view.addSubview(profileSwiftUIController.view)
        profileSwiftUIController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileSwiftUIController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileSwiftUIController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            profileSwiftUIController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            profileSwiftUIController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        self.profileSwiftUIController = profileSwiftUIController
    }
    
    private func handleAuthTap() {
        guard Thread.current.isMainThread else {
            return
        }
        MMMusicAuthManager.shared.handleMusicAuthorization() { [weak self] isAuthorized in
            if isAuthorized {
                DispatchQueue.main.async {
                    let vc = MMTabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
        }
    }
}
