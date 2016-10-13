//
//  databaseHelper.swift
//  SQLiteCRUD
//
//  Created by Diederich Kroeske on 06/10/2016.
//  Copyright © 2016 Diederich Kroeske. All rights reserved.
//

import Foundation

class DataBaseHelper: NSObject {
    
    static let sharedInstance = DataBaseHelper()
    
    var db : OpaquePointer? = nil
    
    override init() {
        let path = Bundle.main.path(forResource: "airports", ofType: "sqlite")
        if sqlite3_open(path!, &db) != SQLITE_OK {
            print("Error opening database!!")	
        }
    }

    func read() -> [Airport] {
        
        // Empty array
        var result = [Airport]();
        
        // Query
        let query = "SELECT * FROM airports;"
        
        // Prepare query and execute
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error query: \(errmsg)")
            return result
        }
        
        // Construct
        while sqlite3_step(statement) == SQLITE_ROW {
            var airport: Airport = Airport()
            airport.icao = String(cString: sqlite3_column_text(statement, 0));
            airport.name = String(cString: sqlite3_column_text(statement, 1));
            airport.iso_country = String(cString: sqlite3_column_text(statement, 5));
            airport.longitude = Double(String(cString: sqlite3_column_text(statement, 2)));
            airport.latitude = Double(String(cString: sqlite3_column_text(statement, 3)));
            airport.elevation = Double(String(cString: sqlite3_column_text(statement, 4)));
            result.append(airport)
        }
        
        return result
    }
    
    func getCountries() -> [String] {
        
        // Empty array
        var result = [String]();
        
        // Query
        let query = "SELECT iso_country FROM airports;"
        
        // Prepare query and execute
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("error query: \(errmsg)")
            return result
        }
        
        // Construct
        while sqlite3_step(statement) == SQLITE_ROW {
           result.append(String(cString: sqlite3_column_text(statement, 0)))
        }
        
        return result
    }
    
}
