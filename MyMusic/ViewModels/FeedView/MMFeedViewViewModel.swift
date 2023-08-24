//
//  MMFeedViewViewModel.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit

protocol MMFeedViewViewModelDelegate: AnyObject {
    func didFetchInitialSongs()
}

final class MMFeedViewViewModel: NSObject {
    
    weak var delegate: MMFeedViewViewModelDelegate?
    
    public private(set) var cellViewModels = [MMFeedViewTableViewCellViewModel]()
    
    public func fetchSongs() {
        cellViewModels = [.init(trackName: "Summer Sixteen",
                                artistName: "Drake",
                                imageURL: URL(string: "https://www.apple.com/v/apple-music/x/images/shared/og__ckjrh2mu8b2a_image.png"))]
        
        delegate?.didFetchInitialSongs()
    }
}

// MARK: TableViewDelegate

extension MMFeedViewViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MMFeedViewTableViewCell.cellIdentifier,
            for: indexPath
        ) as? MMFeedViewTableViewCell else {
            fatalError()
        }
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        return cell
    }
}
