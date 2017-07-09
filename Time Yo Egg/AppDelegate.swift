//
//  AppDelegate.swift
//  Time Yo Egg
//
//  Created by Vince Kearney on 08/07/2017.
//  Copyright © 2017 vince. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    // MARK: Properties
    @IBOutlet weak var startMenuItem: NSMenuItem!
    @IBOutlet weak var restartMenuItem: NSMenuItem!
    @IBOutlet weak var stopMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        enableMenus(start: true, stop: false, reset: false)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func enableMenus(start: Bool, stop: Bool, reset: Bool) {
        startMenuItem.isEnabled = start
        restartMenuItem.isEnabled = reset
        stopMenuItem.isEnabled = stop
    }
}

