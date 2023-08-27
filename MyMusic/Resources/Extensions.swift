//
//  Extensions.swift
//  MyMusic
//
//  Created by Carson Gross on 8/24/23.
//

import UIKit

extension UIView {
    public func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}
