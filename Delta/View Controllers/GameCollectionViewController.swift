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
import Kingfisher

class GameCollectionViewController: UIViewController {

    // MARK: - Init

    init() {
        let request: NSFetchRequest<Game> = Game.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Game.name), ascending: false)]
        games = viewContext.rx.entities(fetchRequest: request)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Games", comment: "Games")

        view.addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.itemSelected(indexPath: indexPath)
        }).disposed(by: bag)

        games.bind(to: collectionView.rx.items(cellIdentifier: String(describing: GameCell.self), cellType: GameCell.self)) { _, game, cell in
            cell.titleLabel.text = game.name
            
            if let artwork = game.artwork?.url {
                cell.imageView.kf.setImage(with: artwork)
            }
        }.disposed(by: bag)
    }
    
    // MARK: - Private Methods
    
    private func itemSelected(indexPath: IndexPath) {
        guard
            let game: Game = try? collectionView.rx.model(at: indexPath),
            let path = game.rom?.path else { return }

        load(url: URL(fileURLWithPath: path), type: .gba)
    }
    
    private func load(url: URL, type: GameType) {
        let controller = GameViewController()
        controller.game = DeltaCore.Game(fileURL: url, type: type)
        controller.delegate = self
        present(controller, animated: false, completion: nil)
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

    private let viewContext = DataController.main.viewContext
    private let bag = DisposeBag()
    
    let games: Observable<[Game]>

}

extension GameCollectionViewController: GameViewControllerDelegate {
    
    func gameViewController(_ gameViewController: GameViewController, handleMenuInputFrom gameController: GameController) {
        gameViewController.pauseEmulation()
        gameViewController.dismiss(animated: true, completion: nil)
    }
    
}
