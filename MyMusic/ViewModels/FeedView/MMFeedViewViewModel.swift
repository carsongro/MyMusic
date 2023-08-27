//
//  MMFeedViewViewModel.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit
import MusicKit

protocol MMFeedViewViewModelDelegate: AnyObject {
    func didFetchInitialSongs()
}

final class MMFeedViewViewModel: NSObject {
    
    weak var delegate: MMFeedViewViewModelDelegate?
     
    public private(set) var cellViewModels = [MMFeedViewTableViewCellViewModel]()
    
    public func fetchInitialSongs() {
        
        var request = MusicPersonalRecommendationsRequest()
        request.limit = 5
        
        
        delegate?.didFetchInitialSongs()
    }
}
