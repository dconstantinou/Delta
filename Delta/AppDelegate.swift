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
        ExternalGameControllerManager.shared.startMonitoring()

        configureWindow()
        try! importGames()

        return true
    }

    // MARK: - Private Methods
 
    private func configureWindow() {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [GameSystemPageViewController()]
        navigationController.navigationBar.barStyle = .black
        
        window = UIWindow()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func importGames() throws {
        let library = GameLibraryController()

        let GBA = Bundle.main.urls(forResourcesWithExtension: "gba", subdirectory: nil) ?? []
        let GBC = Bundle.main.urls(forResourcesWithExtension: "gbc", subdirectory: nil) ?? []
        let SNES = Bundle.main.urls(forResourcesWithExtension: "sfc", subdirectory: nil) ?? []
        let ROMS = GBA + GBC + SNES

        try ROMS.forEach(library.importFile)
    }

    // MARK: - Stored Properties
    
    var window: UIWindow?

}
