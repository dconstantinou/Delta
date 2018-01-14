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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let count = CGFloat(3)
        let width = view.bounds.width - collectionViewLayout.sectionInset.left - collectionViewLayout.sectionInset.right - (collectionViewLayout.minimumInteritemSpacing * count - 1)

        collectionViewLayout.itemSize = CGSize(width: width / count, height: 160.0)
    }

    // MARK: - Private Methods
    
    private func itemSelected(indexPath: IndexPath) {
        guard
            let game: Game = try? collectionView.rx.model(at: indexPath),
            let url = game.rom?.url,
            FileManager.default.fileExists(atPath: url.path) else { return }

        load(url: url, type: .gba)
    }
    
    private func load(url: URL, type: GameType) {
        let controller = GameViewController()
        controller.game = DeltaCore.Game(fileURL: url, type: type)
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    // MARK: - Stored Properties

    lazy private var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)

        return collectionViewLayout
    }()
    
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
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
