//
//  ViewController.swift
//  Done
//
//  Created by Andrea Mazzini on 28/03/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//
import Realm
import UIKit
import MMWormhole

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    var dataSource: RLMResults!
    let wormhole = MMWormhole(applicationGroupIdentifier: "group.it.fancypixel.Done", optionalDirectory: "done")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.wormhole.listenForMessageWithIdentifier("watchUpdate", listener: { (_) -> Void in
            self.reloadEntries()
        })
        reloadEntries()
        
        tableView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        let textField = UITextField(frame: CGRectMake(10, 10, self.view.frame.size.width - 20, 40))
        textField.delegate = self
        textField.textColor = UIColor.whiteColor()
        let placeholer = NSAttributedString(string: "Add an item", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        textField.attributedPlaceholder = placeholer
        container.addSubview(textField)
        return container
    }
    
    func reloadEntries() {
        dataSource = Entry.allObjects()
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (countElements(textField.text) == 0) {
            return false
        }
        textField.resignFirstResponder()
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        let entry = Entry()
        entry.title = textField.text
        entry.completed = false
        realm.addObject(entry)
        realm.commitWriteTransaction()
        self.wormhole.passMessageObject("update", identifier: "mainUpdate")
        reloadEntries()
        return true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataSource.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        let entry = dataSource[UInt(indexPath.row)] as Entry
        cell.textLabel!.text = entry.title
        cell.accessoryType = entry.completed ? .Checkmark : .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entry = dataSource[UInt(indexPath.row)] as Entry
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        entry.completed = !entry.completed
        realm.commitWriteTransaction()
        self.wormhole.passMessageObject("update", identifier: "mainUpdate")
        reloadEntries()
    }
    
}

