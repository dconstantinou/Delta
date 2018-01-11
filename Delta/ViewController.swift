//
//  ViewController.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        client.retrieveGames(search: "Pokemon - Fire Red Version").subscribe(onSuccess: { (games) in
            guard let game = games.first else {
                return
            }
            
            self.client.retrieveCover(game: game, size: .huge).subscribe(onSuccess: { image in
                
            })
        }).disposed(by: bag)
    }
    
    var client = IGDBClient()
    private let bag = DisposeBag()

}
