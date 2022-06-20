//
//  Imageview+Extensions.swift
//  MovieList
//
//  Created by soujanya Balusu on 16/06/22.
//

import UIKit

extension UIImageView {
    func imageCorners(_ radius : CGFloat) {
        layer.cornerRadius = radius
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

