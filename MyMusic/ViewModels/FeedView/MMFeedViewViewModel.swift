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
                                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/2/2f/SummerSixteen.jpg")),
                          .init(trackName: "Summer Sixteen",
                                artistName: "Drake",
                                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/2/2f/SummerSixteen.jpg")),
                          .init(trackName: "Summer Sixteen",
                                artistName: "Drake",
                                imageURL: URL(string: "https://upload.wikimedia.org/wikipedia/en/2/2f/SummerSixteen.jpg"))]
        
        delegate?.didFetchInitialSongs()
    }
}
