//
//  IGDBClient.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import Moya

enum IGDBTarget {
    
    enum ImageSize: String {
        case huge = "screenshot_huge"
    }

    case games(query: String)
    case image(identifier: String, size: ImageSize)

}

extension IGDBTarget: TargetType {
    
    var baseURL: URL {
        switch self {
        case .image:
            return URL(string: "https://images.igdb.com")!
        default:
            return URL(string: "https://api-2445582011268.apicast.io")!
        }
    }
    
    var path: String {
        switch self {
        case .games:
            return "/games/"
        case .image(let identifier, let size):
            return "/igdb/image/upload/t_\(size.rawValue)/\(identifier).jpg"
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .games(let search):
            return Task.requestParameters(
                parameters: [
                    "search": search,
                    "fields": "name,cover",
                ],
                encoding: URLEncoding()
            )
        default:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "user-key": "7b0dbb347165ad8a76b9e514bd8d9b3e"
        ]
    }
    
}
