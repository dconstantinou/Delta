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
import GBADeltaCore

final class GameCollectionViewController: UIViewController {

    // MARK: - Init

    init(systemID: String, core: DeltaCoreProtocol) throws {
        guard let system = try System.system(for: systemID, context: viewContext) else {
            fatalError("Unable to load system with identifier: \(systemID)")
        }

        let request: NSFetchRequest<Game> = Game.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Game.system), system)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Game.name), ascending: true)]
        
        self.games = viewContext.rx.entities(fetchRequest: request)
        self.core = core

        Delta.register(core)

        super.init(nibName: nil, bundle: nil)
        title = system.shortName
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.pinToSuperviewEdges()
        
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.itemSelected(indexPath: indexPath)
        }).disposed(by: bag)

        games.bind(to: collectionView.rx.items(cellIdentifier: String(describing: GameCell.self), cellType: GameCell.self)) { [weak self] _, game, cell in
            self?.configure(cell: cell, with: game)
        }.disposed(by: bag)

        NotificationCenter.default.rx.notification(.externalGameControllerDidConnect).subscribe(onNext: { [weak self] (notification) in
            self?.controllerWasConnected(notification: notification)
        }).disposed(by: bag)
        
        NotificationCenter.default.rx.notification(.externalGameControllerDidDisconnect).subscribe(onNext: { [weak self] (notification) in
            self?.controllerWasDisconnected(notification: notification)
        }).disposed(by: bag)
    }

    // MARK: - Private Methods
    
    private func configure(cell: GameCell, with game: Game) {
        cell.titleLabel.text = game.name

        if let artwork = game.artwork?.url {
            cell.imageView.kf.setImage(with: artwork)
        }
    }

    private func controllerWasConnected(notification: Notification) {
        guard let viewController = presentedViewController as? GameViewController else {
            return
        }
        
        guard let controller = notification.object as? MFiGameController, controller.playerIndex == 0 else {
            return
        }
        
        enable(controller: controller, for: viewController)
    }
    
    private func controllerWasDisconnected(notification: Notification) {
        guard let viewController = presentedViewController as? GameViewController else {
            return
        }

        guard let controller = notification.object as? MFiGameController else {
            return
        }

        disable(controller: controller, for: viewController)
    }
    
    private func enable(controller: MFiGameController, for viewController: GameViewController) {
        guard let emulator = viewController.emulatorCore else {
            return
        }
        
        if var inputMapping = controller.defaultInputMapping as? GameControllerInputMapping, core == GBA.core {
            inputMapping.set(GBAGameInput.b, forControllerInput: MFiGameController.Input.x)
            controller.addReceiver(emulator, inputMapping: inputMapping)
        } else {
            controller.addReceiver(emulator)
        }

        controller.addReceiver(viewController)
        viewController.controllerView.isHidden = true
    }
    
    private func disable(controller: MFiGameController, for viewController: GameViewController) {
        guard let emulator = viewController.emulatorCore else {
            return
        }

        controller.removeReceiver(emulator)
        controller.removeReceiver(viewController)
        viewController.controllerView.isHidden = false
    }
    
    private func itemSelected(indexPath: IndexPath) {
        guard
            let game: Game = try? collectionView.rx.model(at: indexPath),
            let url = game.rom?.url,
            FileManager.default.fileExists(atPath: url.path) else { return }

        load(url: url)
    }
    
    private func load(url: URL) {
        let viewController = GameViewController()
        viewController.game = DeltaCore.Game(fileURL: url, type: core.gameType)
        viewController.delegate = self

        present(viewController, animated: true) { [weak self] in
            guard let controller = ExternalGameControllerManager.shared.connectedControllers.first as? MFiGameController else {
                return
            }
            
            self?.enable(controller: controller, for: viewController)
        }
    }
    
    private func showMainMenuConfirmationAlertController(from controller: GameViewController) {
        let confirm = UIAlertAction(title: "Quit Game", style: .destructive) { _ in
            controller.dismiss(animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "Keep Playing", style: .default) { _ in
            controller.resumeEmulation()
        }

        let alert = UIAlertController(title: "Quit Game?", message: "Are you sure you want to quit the game?", preferredStyle: .alert)
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        controller.pauseEmulation()
        controller.present(alert, animated: true, completion: nil)
    }

    // MARK: - Stored Properties

    lazy private var collectionViewLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 15
        collectionViewLayout.minimumLineSpacing = 15
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 20.0, right: 15.0)
        collectionViewLayout.itemSize = CGSize(width: 100.0, height: 150.0)
        
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
    let core: DeltaCoreProtocol

}

extension GameCollectionViewController: GameViewControllerDelegate {
    
    func gameViewController(_ controller: GameViewController, handleMenuInputFrom gameController: GameController) {
        showMainMenuConfirmationAlertController(from: controller)
    }
    
}
