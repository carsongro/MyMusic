//
//  MMFeedViewTableViewCellViewModel.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit

struct MMFeedViewTableViewCellViewModel {
    let trackName: String
    let artistName: String
    let imageURL: URL?
    
    public func fetchImage() async throws -> UIImage {
        guard let imageURL = imageURL else {
            throw ImageLoadingError.invalidURL
        }
        
        return try await MMImageLoader.shared.fetchImage(imageURL)
    }
}
