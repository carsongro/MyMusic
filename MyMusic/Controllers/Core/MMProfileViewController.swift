//
//  MMProfileViewController.swift
//  MyMusic
//
//  Created by Carson Gross on 8/23/23.
//

import SwiftUI
import SafariServices
import MusicKit

/// Controller for the user profile and settings
class MMProfileViewController: UIViewController {
    
    // MARK: Properties
    
    private var profileSwiftUIController: UIHostingController<MMProfileView>?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        addSwiftUIController()
    }
    
    // MARK: Private
    
    private func addSwiftUIController() {
        let profileSwiftUIController = UIHostingController(
            rootView: MMProfileView(viewModel: MMProfileViewViewModel(
                cellViewModels: MMProfileOption.allCases.compactMap {
                    return MMProfileViewCellViewModel(type: $0) { [weak self] option in
                        DispatchQueue.main.async {
                            self?.handleProfileTap(option: option)
                        }
                    }
                })
            )
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
    
    private func handleProfileTap(option: MMProfileOption) {
        guard Thread.current.isMainThread else {
            return
        }
        
        switch option {
        case .sourceCode:
            if let url = option.targetURL {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        }
    }
}
