//
//  MMFeedViewViewModel.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit
import MusicKit

protocol MMFeedViewViewModelDelegate: AnyObject {
    func didFetchInitialTracks()
}

final class MMFeedViewViewModel: NSObject {
    
    /// The MusicKit player to use for Apple Music playback.
    private let player = ApplicationMusicPlayer.shared
    
    /// The state of the MusicKit player to use for Apple Music playback.
    private var playerState = ApplicationMusicPlayer.shared.state
    
    private var loadedTracks = MusicItemCollection<Track>()
    
    /// `true` when the player is playing.
    private var isPlaying: Bool {
        return (playerState.playbackStatus == .playing)
    }
    
    weak var delegate: MMFeedViewViewModelDelegate?
    
    public private(set) var cellViewModels = [MMFeedViewTableViewCellViewModel]()
    
    public var lastDisplayedCell: MMFeedViewTableViewCell?
    public var lastDisplayedCellScrollPosition: CGFloat = 0
    public var displayedCell: MMFeedViewTableViewCell?
    
    enum FeedViewSection {
        case main
    }
    
    // MARK: Public
    
    public func fetchInitialTracks() {
        Task {
            await fetchRecommendedTracks()
        }
    }
    
    /// Determines whether to skip to next or previous song based on the users scroll direction
    /// - Parameter scrollDirection: The direction the user was scrolling
    public func handleNewDisplayedCell(scrollDirection: ScrollDirection) {
        Task {
            do {
                switch scrollDirection {
                case .up:
                    try await player.skipToPreviousEntry()
                case .down:
                    try await player.skipToNextEntry()
                }
                
                if !isPlaying {
                    beginPlaying()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// The action to perform when the user taps the screen.
    public func handleCellSelected() {
        if !isPlaying {
            Task {
                do {
                    try await player.play()
                } catch {
                    print("Failed to resume playing with error: \(error).")
                }
            }
        } else {
            player.pause()
        }
    }
    
    // MARK: Private
    
    /// A convenience method for beginning music playback.
    ///
    /// Call this instead of `MusicPlayer`’s `play()`
    /// method whenever the playback queue is reset.
    private func beginPlaying() {
        Task {
            do {
                try await player.play()
            } catch {
                print("Failed to prepare to play with error: \(error).")
            }
        }
    }
    
    /// Get the initial list of songs when the view loads
    private func fetchRecommendedTracks() async {
        let fetchTracksTask = Task { () -> MusicItemCollection<Track> in
            do {
                var request = MusicPersonalRecommendationsRequest()
                request.limit = 1
                let response = try await request.response()
                
                guard let playlistId = response.recommendations.first?.playlists.first?.id else {
                    throw MMError.playlistNotFound
                }
                
                var playlistRequest = MusicCatalogResourceRequest<Playlist>(
                    matching: \.id,
                    equalTo: MusicItemID(playlistId.rawValue)
                )
                playlistRequest.properties = [.tracks]
                let playlistResponse = try await playlistRequest.response()
                
                guard let tracks = playlistResponse.items.first?.tracks else {
                    throw MMError.playlistNotFound
                }
                
                return tracks
            } catch {
                throw error
            }
        }
        
        let result = await fetchTracksTask.result
        
        do {
            let tracks = try result.get()
            await loadTracks(tracks: tracks)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @MainActor
    /// Updates cellViewModels, notifys the delegate, and begins playing
    /// - Parameter tracks: Tracks which will be loaded into the cellViewModels
    private func loadTracks(tracks: MusicItemCollection<Track>) {
        guard let firstTrack = tracks.first else {
            return
        }
        
        loadedTracks = tracks
        
        cellViewModels = loadedTracks.compactMap {
            MMFeedViewTableViewCellViewModel(
                trackName: $0.title,
                artistName: $0.artistName,
                imageURL: $0.artwork?.url(
                    width: 500,
                    height: 500
                )
            )
        }
        
        self.delegate?.didFetchInitialTracks()
        
        self.player.queue = ApplicationMusicPlayer.Queue(for: self.loadedTracks, startingAt: firstTrack)
        self.playerState.repeatMode = .one
        self.beginPlaying()
    }
}

enum ScrollDirection {
    case up
    case down
}
