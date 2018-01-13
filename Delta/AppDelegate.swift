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

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [GameCollectionViewController()]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        let GBA = Bundle.main.urls(forResourcesWithExtension: "gba", subdirectory: nil) ?? []
        for rom in GBA {
            try? importROM(url: rom)
        }
        
        return true
    }
    
    private func importROM(url: URL) throws {
        print("\nImporting... \(url.lastPathComponent)")
        
        let md5 = try MD5(forFileURL: url)
        print("Locating release for MD5: \(md5.uppercased())")
        
        let db = try OpenVGDB()
        if let release = try db.release(forMD5: md5.uppercased()) {
            print("Found Release: \(release.name) \(release.region), \(release.artwork))")
        } else {
            print("No release found!")
        }
    }

    func MD5(forFileURL url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        _ = data.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
            CC_MD5(body, CC_LONG(data.count), &digest)
        }

        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    // MARK: - Private Methods
    
    private func registerCores() {
        Delta.register(GBA.core)
    }

    // MARK: - Stored Properties
    
    var window: UIWindow?

}
