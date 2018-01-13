//
//  OpenVGDB.swift
//  Delta
//
//  Created by Dino Constantinou on 12/01/2018.
//  Copyright © 2018 Dino Constantinou. All rights reserved.
//

import SQLite

struct OpenVGDB {
    
    // MARK: - Types
    
    struct Release {
        let name: String
        let summary: String
        let region: String
        let artwork: String?
        let rom: ROM
        let system: System
    }
    
    struct ROM {
        let file: String
        let md5: String
    }
    
    struct System {
        let identifier: String
        let name: String
        let shortName: String
    }

    // MARK: - Init

    init(bundle: Bundle = .main) throws {
        guard let path = bundle.path(forResource: "openvgdb", ofType: "sqlite") else {
            fatalError("Error locating openvgdb.sqlite file in bundle \(bundle).")
        }
        
        connection = try Connection(path, readonly: true)
    }
    
    // MARK: - Public Methods

    func release(forMD5 md5: String) throws -> Release? {
        let roms = Table("ROMs")
        let releases = Table("RELEASES")
        let regions = Table("REGIONS")
        let systems = Table("SYSTEMS")

        let releaseTitle = Expression<String>("releaseTitleName")
        let releaseDescription = Expression<String>("releaseDescription")
        let releaseCoverFront = Expression<String?>("releaseCoverFront")

        let regionID = Expression<Int64>("regionID")
        let region = Expression<String>("regionName")
        
        let romID = Expression<Int64>("romID")
        let romFileName = Expression<String>("romFileName")
        let romHashMD5 = Expression<String>("romHashMD5")
        
        let systemID = Expression<Int64>("systemID")
        let systemOEID = Expression<String>("systemOEID")
        let systemName = Expression<String>("systemName")
        let systemShortName = Expression<String>("systemShortName")

        let query = releases
            .select(distinct: releaseTitle, releaseDescription, releaseCoverFront, region, romFileName, romHashMD5, systemOEID, systemName, systemShortName)
            .filter(romHashMD5 == md5)
            .join(roms, on: releases.namespace(romID) == roms.namespace(romID))
            .join(regions, on: roms.namespace(regionID) == regions.namespace(regionID))
            .join(systems, on: roms.namespace(systemID) == systems.namespace(systemID))

        let results = try connection.prepare(query)
        guard let row = Array(results).last else {
            return nil
        }

        return Release(
            name: row[releaseTitle],
            summary: row[releaseDescription],
            region: row[region],
            artwork: row[releaseCoverFront],
            rom: ROM(
                file: row[romFileName],
                md5: row[romHashMD5]
            ),
            system: System(
                identifier: row[systemOEID],
                name: row[systemName],
                shortName: row[systemShortName]
            )
        )
    }
    
    // MARK: - Private Methods
    
    private let connection: Connection
        
}
