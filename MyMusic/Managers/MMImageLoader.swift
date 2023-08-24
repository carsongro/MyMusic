//
//  MMImageLoader.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit

final class MMImageLoader {
    static let shared = MMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    public func fetchImage(_ url: URL) async throws -> UIImage {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key),
           let image = UIImage(data: data as Data) {
            return image
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ImageLoadingError.invalidServerResponse
        }
        
        guard let image = UIImage(data: data as Data) else {
            throw ImageLoadingError.unsupportedImage
        }
        
        let value = data as NSData
        self.imageDataCache.setObject(value, forKey: key)
        
        return image
    }
}

enum ImageLoadingError: Error {
    case invalidServerResponse
    case unsupportedImage
    case invalidURL
}
