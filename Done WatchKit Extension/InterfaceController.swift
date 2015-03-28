//
//  InterfaceController.swift
//  Done WatchKit Extension
//
//  Created by Andrea Mazzini on 28/03/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import WatchKit
import Foundation
import Realm

class InterfaceController: WKInterfaceController {

    @IBOutlet var watchTable: WKInterfaceTable!
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.it.fancypixel.Done")!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
        
        reloadTableData()
    }
    
    func reloadTableData() {
        let realm = RLMRealm.defaultRealm()
        let dataSource = Entry.allObjects()

        watchTable.setNumberOfRows(Int(dataSource.count), withRowType: "EntryRow")
        
        for index in 0..<Int(dataSource.count) {
            let entry = dataSource[UInt(index)] as Entry
            if let row = watchTable.rowControllerAtIndex(index) as? EntryTableRowController {
                row.textLabel.setText(entry.title)
            }
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
