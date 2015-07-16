//
//  ViewController.swift
//  Done
//
//  Created by Andrea Mazzini on 28/03/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//
import Realm
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var tableView: UITableView!
    var dataSource: RLMResults!
    var realmToken: RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        realmToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.reloadEntries()
        }
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
        if (count(textField.text) == 0) {
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
        reloadEntries()
        return true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(dataSource.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        if let entry = dataSource[UInt(indexPath.row)] as? Entry {
            cell.textLabel!.text = entry.title
            cell.accessoryType = entry.completed ? .Checkmark : .None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let entry = dataSource[UInt(indexPath.row)] as? Entry {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            entry.completed = !entry.completed
            realm.commitWriteTransaction()
            reloadEntries()
        }
    }
    
}

