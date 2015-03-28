//
//  AppDelegate.swift
//  Done
//
//  Created by Andrea Mazzini on 28/03/15.
//  Copyright (c) 2015 Fancy Pixel. All rights reserved.
//

import UIKit
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let directory: NSURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.it.fancypixel.Done")!
        let realmPath = directory.path!.stringByAppendingPathComponent("db.realm")
        RLMRealm.setDefaultRealmPath(realmPath)
        return true
    }
}

