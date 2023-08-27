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
    
    // MARK: Public
    
    public func fetchInitialSongs() {
        Task {
            do {
                var request = MusicPersonalRecommendationsRequest()
                request.limit = 1
                let response = try await request.response()
                
                guard let playlistId = response.recommendations.first?.playlists.first?.id else {
                    throw MMError.playlistNotFound
                }
                
                var playlistRequest = MusicCatalogResourceRequest<Playlist>(matching: \.id, equalTo: MusicItemID(playlistId.rawValue))
                playlistRequest.properties = [.tracks]
                let playlistResponse = try await playlistRequest.response()
                 
                guard let tracks = playlistResponse.items.first?.tracks else {
                    throw MMError.playlistNotFound
                }
                
                cellViewModels = tracks.compactMap {
                    MMFeedViewTableViewCellViewModel(
                        trackName: $0.title,
                        artistName: $0.artistName,
                        imageURL: $0.artwork?.url(
                            width: 500,
                            height: 500
                        )
                    )
                }
                
                Task { @MainActor [weak self] in
                    self?.delegate?.didFetchInitialSongs()
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
