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

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [GameCollectionViewController()]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        registerCores()
        try! importGames()

        return true
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
    private let viewContext = DataController.main.viewContext

}
