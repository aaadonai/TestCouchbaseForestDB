//
//  DBManager.swift
//  TestCouchbaseForestDB
//
//  Created by Antonio Rodrigues on 3/13/16.
//  Copyright © 2016 Mobitor. All rights reserved.
//

import Foundation

class DBManager {
    
    static let sharedInstance = DBManager()
    
    static let dbName = "testdb"
    
    class private func standardDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    }
    
    var directory: String?
    
    func appDatabase() throws -> CBLDatabase {
        if directory == nil {
            directory = DBManager.standardDirectory()
            print("directory: \(directory)")
        }
        
        do {
            let databaseManager = try CBLManager(directory: directory!, options: nil)
            databaseManager.storageType = kCBLForestDBStorage
            let db = try databaseManager.databaseNamed(DBManager.dbName)
            return db
        } catch let error as NSError {
            print("Error retrieving database.")
            throw error
        }
    }
    
    func saveDoc(docId: String, docDict: [String: AnyObject]) {
        
        let database = try! appDatabase()
        // Save the document:
        let doc = database.documentWithID(docId)
        do {
            try doc!.putProperties(docDict)
        } catch let error as NSError {
            print("Couldn't save new item: \(error)")
        }
        
        
    }

    func getDoc(docId: String) -> [String: AnyObject]? {
        let database = try! appDatabase()

        if let doc = database.existingDocumentWithID(docId) {
            return doc.properties
        }
        return nil
    }
    
    
    func setViews() -> CBLDatabase {
        
        let database = try! appDatabase()

        database.viewNamed("list_view").setMapBlock( {
            (doc, emit) in
            
            let name = doc["name"] as! String
            let nameKey:AnyObject = ["name", name]

            emit(nameKey, doc)
            
            let address = doc["address"] as! String
            let addressKey:AnyObject = ["address", address]
            
            emit(addressKey, doc)
            
            let status = doc["status"] as! String
            let statusKey:AnyObject = ["status", status]
            
            emit(statusKey, doc)
            
            if let date = doc["endDate"] as? [String: AnyObject] {
                if let endDate = date["ticks"]  {
                    print("view end date: \(endDate)")
                    let key =  ["docEndDate", endDate]
                    emit(key, doc)

                }
            }
            }, version: "2")
        
            return database
    }
    
    func deleteDB() {
        do {
            let database = try appDatabase()
            try database.deleteDatabase()
        } catch let error {
            print("error deleteing db: \(error)")
        }
    }
}
