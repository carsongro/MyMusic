//
//  MMProfileViewCellViewModel.swift
//  MyMusic
//
//  Created by Carson Gross on 8/26/23.
//

import UIKit

struct MMProfileViewCellViewModel: Identifiable {
    let id = UUID()
    
    public let type: MMProfileOption
    public let onTapHandler: (MMProfileOption) -> Void
    
    // MARK: Init
    
    init(type: MMProfileOption, onTapHandler: @escaping (MMProfileOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK: Public
    
    public var image: UIImage? {
        type.iconImage
    }
    
    public var title: String {
        type.displayTitle
    }
    
    public var iconContainerColor: UIColor {
        type.iconContainerColor
    }
}
