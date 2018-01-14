//
//  File.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    // MARK: - Types
    
    enum BarButtonItemType {
        case done
        case settings
    }
    
    // MARK: - Init
    
    convenience init(type: BarButtonItemType, target: Any?, action: Selector?) {
        switch type {
        case .done:
            self.init(barButtonSystemItem: .done, target: target, action: action)
        case .settings:
            self.init(image: UIImage(asset: .iconSettings), style: .plain, target: target, action: action)
        }
    }
    
}
