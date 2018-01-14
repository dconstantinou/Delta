//
//  AppDelegate.swift
//  Delta
//
//  Created by Dino Constantinou on 11/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import UIKit
import DeltaCore
import GBCDeltaCore
import GBADeltaCore
import SNESDeltaCore
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
        navigationController.viewControllers = [
//            GameCollectionViewController(system: "openemu.system.snes", type: GameType.snes),
//            GameCollectionViewController(system: "openemu.system.gba", type: GameType.gba),
            GameCollectionViewController(system: "openemu.system.gb", type: GameType.gbc)
        ]
        
        navigationController.navigationBar.barStyle = .black
        window?.rootViewController = navigationController

        ExternalGameControllerManager.shared.startMonitoring()

        registerCores()
        try! importGames()

        return true
    }

    // MARK: - Private Methods
 
    private func registerCores() {
        Delta.register(GBA.core)
        Delta.register(GBC.core)
        Delta.register(SNES.core)
    }
    
    private func importGames() throws {
        let library = GameLibraryController()

        let GBA = Bundle.main.urls(forResourcesWithExtension: "gba", subdirectory: nil) ?? []
        let GBC = Bundle.main.urls(forResourcesWithExtension: "gbc", subdirectory: nil) ?? []
        let SNES = Bundle.main.urls(forResourcesWithExtension: "smc", subdirectory: nil) ?? []
        let ROMS = GBA + GBC + SNES

        try ROMS.forEach(library.importFile)
    }

    // MARK: - Stored Properties
    
    var window: UIWindow?

}

