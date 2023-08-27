//
//  MMProfileOption.swift
//  MyMusic
//
//  Created by Carson Gross on 8/26/23.
//

import UIKit

enum MMProfileOption: CaseIterable {
    case sourceCode
    
    var displayTitle: String {
        switch self {
        case .sourceCode:
            return "View Source Code"
        }
    }
    
    var targetURL: URL? {
        switch self {
        case .sourceCode:
            return URL(string: "https://github.com/carsongro/MyMusic")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .sourceCode:
            return .systemBlue
        }
    }
    
    var iconImage: UIImage? {
        switch self {
        case .sourceCode:
            return UIImage(systemName: "doc.text")
        }
    }
}
