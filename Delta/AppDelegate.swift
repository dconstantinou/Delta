//
//  AppDelegate.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import DeltaCore
import GBADeltaCore
import CommonCryptoModule
import CoreData
import GameController

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let navigationController = UINavigationController()
        navigationController.viewControllers = [GameCollectionViewController()]
        navigationController.navigationBar.barStyle = .black
        window?.rootViewController = navigationController

        registerCores()
        try! importGames()

        ExternalGameControllerManager.shared.startMonitoring()
        NotificationCenter.default.addObserver(self, selector: #selector(self.externalGameControllerConnected), name: .externalGameControllerDidConnect, object: nil)

        return true
    }

    @objc func externalGameControllerConnected(notification: Notification) {
        guard
            let controller = notification.object as? MFiGameController,
            let viewController = window?.rootViewController as? GameViewController,
            let emulator = viewController.emulatorCore,
            var inputMapping = controller.defaultInputMapping as? GameControllerInputMapping else { return }

        inputMapping.set(GBAGameInput.a, forControllerInput: MFiGameController.Input.b)
        inputMapping.set(GBAGameInput.b, forControllerInput: MFiGameController.Input.x)

        controller.addReceiver(emulator, inputMapping: inputMapping)
        viewController.controllerView.isHidden = true
    }
    
    @objc func configureGameControllerInputMapping(notification: Notification) {
        guard let controller = notification.object as? MFiGameController else {
            return
        }

        let root = UINavigationController(rootViewController: MFiGameControllerInputMappingViewController(controller: controller, type: .gba))
        window?.rootViewController = root
    }

    // MARK: - Private Methods
 
    private func registerCores() {
        Delta.register(GBA.core)
    }
    
    private func importGames() throws {
        let library = GameLibraryController()

        let GBA = Bundle.main.urls(forResourcesWithExtension: "gba", subdirectory: nil) ?? []
        try GBA.forEach(library.importFile)
    }

    // MARK: - Stored Properties
    
    var window: UIWindow?

}

