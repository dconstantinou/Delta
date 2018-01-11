//
//  IGDBImage.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import Foundation

struct IGDBImage: Codable {

    let identifier: String
    
    enum CodingKeys: String, CodingKey {
        case identifier = "cloudinary_id"
    }
    
}
