//
//  IGDBClient.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import RxSwift
import Moya

struct IGDBClient {
    
    func retrieveGames(search query: String) -> Single<[IGDBGame]> {
        return provider.rx.request(.games(query: query)).map([IGDBGame].self)
    }
    
    func retrieveCover(game: IGDBGame, size: IGDBTarget.ImageSize) -> Single<UIImage?> {
        guard let cover = game.cover else {
            return .just(nil)
        }

        return provider.rx.request(.image(identifier: cover.identifier, size: size)).mapImage()
    }

    var provider = MoyaProvider<IGDBTarget>(plugins: [NetworkLoggerPlugin()])
    
}
