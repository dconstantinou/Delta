//
//  Game.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import Foundation

struct Game: Codable {

    let name: String
    let cover: Image?
    
    enum CodingKeys: String, CodingKey {
        case name
        case cover
    }

}
