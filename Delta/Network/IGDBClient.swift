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
    
    func retrieveGames(search query: String) -> Single<[Game]> {
        return provider.rx.request(.games(query: query)).map([Game].self)
    }
    
    func retrieveCover(game: Game, size: IGDBTarget.ImageSize) -> Single<UIImage?> {
        guard let cover = game.cover else {
            return .just(nil)
        }

        return provider.rx.request(.image(identifier: cover.identifier, size: size)).mapImage()
    }

    var provider = MoyaProvider<IGDBTarget>(plugins: [NetworkLoggerPlugin()])
    
}
