//
//  UIImage.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit

extension UIImage {
    
    // MARK: - Types

    enum Asset: String {
        case iconSettings = "icon_settings"
    }
    
    // MARK: - Public Methods
    
    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }
    
}
