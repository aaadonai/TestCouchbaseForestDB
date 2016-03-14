//
//  ViewController.swift
//  TestCouchbaseForestDB
//
//  Created by Antonio Rodrigues on 3/13/16.
//  Copyright © 2016 Mobitor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonDeleteDBTapped(sender: AnyObject) {
        DBManager.sharedInstance.deleteDB()
    }
    
    @IBAction func buttonCreateDoc1Tapped(sender: AnyObject) {
        createDoc("doc_1")
    }
    
    @IBAction func buttonCreateDoc2Tapped(sender: AnyObject) {
        createDoc("doc_2")
    }
    
    @IBAction func buttonQueryDocTapped(sender: AnyObject) {
        queryDocs()
    }
    
    @IBAction func buttonUpdateDoc2Tapped(sender: AnyObject) {
        
        updateDoc2()
    }
    
    func createDoc(docId: String) {
        let uuid = docId
        var doc = [String: AnyObject]()
        
        doc["name"] = "Test name \(docId)"
        doc["address"] = "28th Street"
        doc["status"] = "live"
        var endDate = [String: AnyObject]()
        endDate["ticks"] = 1457902800000
        endDate["tz"] = "America/Los_Angeles"
        doc["endDate"] = endDate
        
        print("\(docId) with document: \(doc)")
        DBManager.sharedInstance.saveDoc(uuid, docDict: doc)
    }

    func queryDocs() {
        let database =  DBManager.sharedInstance.setViews()
        if let doc1 = DBManager.sharedInstance.getDoc("doc_1") {
            print("doc 1: \( doc1)")
        }
        if let doc2 = DBManager.sharedInstance.getDoc("doc_2") {
            print("doc 2: \( doc2)")
        }

        let query = database.viewNamed("list_view").createQuery()
        do {
        
            
            query.startKey = ["docEndDate",1457902800000]
            query.endKey = ["docEndDate",1457902800000]
                
            query.inclusiveStart = true
            query.inclusiveEnd = true
                
            let rows = try query.run()
            print("query: \(rows)")
            while let resultRow = rows.nextRow() {
                print("key: \( resultRow.key) and  value: \(resultRow.value) , documentId: \(resultRow.documentID)")
            }
        } catch let error {
            print("view error: \(error)")
        }
    }
    
    func updateDoc2() {
        if var doc = DBManager.sharedInstance.getDoc("doc_2") {
            
            var nestNode = [String: AnyObject]()
            var categories = [AnyObject]()
            var category = [String: AnyObject]()
            category["name"] = "category 1"
            category["quantity"] = 123
            categories.append(category)
            nestNode["categories"] = categories
            
            doc["node"] = nestNode
            
            DBManager.sharedInstance.saveDoc("doc_2", docDict: doc)
            
            /*
            "node": {
            "categories": [
            {
            "name": "category 1",
            "quantity": 2
            }
            ]
            },
*/
            
        }
        
    }

}


