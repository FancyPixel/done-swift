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
    var realmToken: RLMNotificationToken?

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.it.fancypixel.Done")!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
        realmToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.reloadTableData()
        }
        reloadTableData()
    }
    
    func reloadTableData() {
        let realm = RLMRealm.defaultRealm()
        let dataSource = Entry.allObjects()

        watchTable.setNumberOfRows(Int(dataSource.count), withRowType: "EntryRow")
        
        for index in 0..<Int(dataSource.count) {
            if let row = watchTable.rowControllerAtIndex(index) as? EntryTableRowController,
                let entry = dataSource[UInt(index)] as? Entry {
                row.textLabel.setText(entry.title)
                let imageName = entry.completed ? "check-completed" : "check-empty"
                row.imageCheck.setImageNamed(imageName)
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let dataSource = Entry.allObjects()
        if let entry = dataSource[UInt(rowIndex)] as? Entry {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            entry.completed = !entry.completed
            realm.commitWriteTransaction()
            reloadTableData()
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
