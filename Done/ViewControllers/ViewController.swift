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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadEntries()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 60))
        let textField = UITextField(frame: CGRectMake(10, 10, self.view.frame.size.width - 20, 40))
        textField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        textField.layer.cornerRadius = 4
        textField.delegate = self
        container.addSubview(textField)
        return container
    }
    
    func reloadEntries() {
        dataSource = Entry.allObjects()
        self.tableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        println(countElements(textField.text))
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
        reloadEntries()
    }
    
}

