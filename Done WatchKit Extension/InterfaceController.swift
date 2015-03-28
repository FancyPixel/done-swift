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
import MMWormhole

class InterfaceController: WKInterfaceController {

    @IBOutlet var watchTable: WKInterfaceTable!
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.it.fancypixel.Done", optionalDirectory: "done")

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.it.fancypixel.Done")!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
        self.wormhole.listenForMessageWithIdentifier("mainUpdate", listener: { (_) -> Void in
            self.reloadTableData()
        })
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
                let imageName = entry.completed ? "check-completed" : "check-empty"
                row.imageCheck.setImageNamed(imageName)
            }
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        let dataSource = Entry.allObjects()
        let entry = dataSource[UInt(rowIndex)] as Entry
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        entry.completed = !entry.completed
        realm.commitWriteTransaction()
        self.wormhole.passMessageObject("update", identifier: "watchUpdate")
        reloadTableData()
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
