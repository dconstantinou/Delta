//
//  ROM.swift
//  Delta
//
//  Created by Dino Constantinou on 14/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import CoreData

extension ROM {
    
    var url: URL? {
        guard
            let path = path,
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }

        return documentsURL.appendingPathComponent(path)
    }
    
}
