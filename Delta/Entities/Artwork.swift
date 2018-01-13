//
//  Artwork.swift
//  Delta
//
//  Created by Dino Constantinou on 13/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import CoreData

extension Artwork {

    var url: URL? {
        guard let source = source else {
            return nil
        }
        
        return URL(string: source)
    }
    
}
