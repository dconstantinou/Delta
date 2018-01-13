//
//  GameCollectionViewController.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import DeltaCore
import CoreData
import RxSwift
import RxCocoa
import RxCoreData

class GameCollectionViewController: UIViewController {

    // MARK: - Init

    init() {
        container = NSPersistentContainer(name: "Delta")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Error loading stores: \(error)")
            }
        })

        let fetchRequest: NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Game.name), ascending: false)]

        games = container.viewContext.rx.entities(fetchRequest: fetchRequest)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.pinToSuperviewEdges()

        games.bind(to: collectionView.rx.items(cellIdentifier: String(describing: GameCell.self), cellType: GameCell.self)) { _, game, cell in
            cell.titleLabel.text = game.name
        }.disposed(by: bag)
    }
    
    // MARK: - Private Methods
    
    private func load(url: URL, type: GameType) {
        let controller = GameViewController()
        controller.game = DeltaCore.Game(fileURL: url, type: type)
        present(controller, animated: true, completion: nil)
    }

    // MARK: - Stored Properties

    lazy private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: 200.0, height: 200.0)
        collectionViewLayout.scrollDirection = .vertical

        return collectionViewLayout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(GameCell.self, forCellWithReuseIdentifier: String(describing: GameCell.self))
        
        return collectionView
    }()

    // MARK: - Stored Properties

    private let bag = DisposeBag()
    
    let container: NSPersistentContainer
    let games: Observable<[Game]>

}
