//
//  GameLibraryController.swift
//  Delta
//
//  Created by Dino Constantinou on 13/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import CoreData
import CommonCryptoModule

struct GameLibraryController {
    
    // MARK: - Public Methods

    func importFile(url: URL) throws {
        let md5 = try MD5(forFileURL: url)
        
        let db = try OpenVGDB()
        guard let release = try db.release(forMD5: md5.uppercased()) else {
            return
        }

        try importGame(for: url, info: release)
        try viewContext.save()
    }
    
    // MARK: - Private Methods
 
    private func importGame(for url: URL, info: OpenVGDB.Release) throws {
        let request: NSFetchRequest<Game> = Game.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Game.rom.md5), info.rom.md5)
        request.fetchLimit = 1
        
        let results = try viewContext.fetch(request)
        guard results.first == nil else {
            return
        }
        
        let game = Game(context: viewContext)
        game.name = info.name
        game.summary = info.summary
        game.rom = try rom(for: url, info: info.rom)
        game.artwork = try artwork(for: info)
        game.system = try system(for: info.system)
    }
    
    private func rom(for url: URL, info: OpenVGDB.ROM) throws -> ROM {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let romURL = documentsURL!.appendingPathComponent(url.lastPathComponent)
        
        try! FileManager.default.copyItem(at: url, to: romURL)

        let rom = ROM(context: viewContext)
        rom.md5 = info.md5
        rom.path = url.lastPathComponent

        return rom
    }
    
    private func artwork(for info: OpenVGDB.Release) throws -> Artwork? {
        guard let source = info.artwork else {
            return nil
        }
        
        let artwork = Artwork(context: viewContext)
        artwork.source = source
        
        return artwork
    }
    
    private func system(for info: OpenVGDB.System) throws -> System {
        let request: NSFetchRequest<System> = System.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(System.identifier), info.identifier)
        request.fetchLimit = 1
        
        let results = try viewContext.fetch(request)
        guard let result = results.first else {
            let system = System(context: viewContext)
            system.identifier = info.identifier
            system.name = info.name
            system.shortName = info.shortName
            
            return system
        }
        
        return result
    }
    
    private func MD5(forFileURL url: URL) throws -> String {
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
    
    // MARK: - Stored Properties
    
    private let viewContext = DataController.main.viewContext
    
}
