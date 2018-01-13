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

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [GameCollectionViewController()]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let db = try! OpenVGDB()
        let release = try! db.release(forMD5: "51901a6e40661b3914aa333c802e24e8".uppercased())
        print("\(release!)")

        return true
    }
    
    // MARK: - Private Methods
    
    private func registerCores() {
        Delta.register(GBA.core)
    }

    // MARK: - Stored Properties
    
    var window: UIWindow?

}
