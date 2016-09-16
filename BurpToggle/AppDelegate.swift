//
//  AppDelegate.swift
//  BurpToggle
//
//  Created by Melvin Lammerts on 04/02/15.
//  Copyright (c) 2015 Melvin Lammerts. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow?
    
    var statusBar = NSStatusBar.system()
    var statusBarItem : NSStatusItem = NSStatusItem()
    
    var menu: NSMenu = NSMenu()
    var toggleProxyMenuItem : NSMenuItem = NSMenuItem()
    var toggleSecureProxyMenuItem : NSMenuItem = NSMenuItem()
    var toggleInterFaceMenuItem : NSMenuItem = NSMenuItem()
    var quitMenuItem : NSMenuItem = NSMenuItem()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func exitNow(_ sender: AnyObject) {
        NSApplication.shared().terminate(self)
    }
    
    override func awakeFromNib() {
        let proxy = Proxy(items: [toggleProxyMenuItem, toggleSecureProxyMenuItem, toggleInterFaceMenuItem])

        statusBarItem = statusBar.statusItem(withLength: -1)
        statusBarItem.menu = menu
        statusBarItem.title = "B"
        
        proxy.setProxyStatusMenu()
        
        toggleProxyMenuItem.action = #selector(proxy.toggleProxy(_:))
        toggleProxyMenuItem.keyEquivalent = ""
        
        proxy.setSecureProxyStatusMenu()
        
        toggleSecureProxyMenuItem.action = #selector(proxy.toggleSecureProxy(_:))
        toggleSecureProxyMenuItem.keyEquivalent = ""
        
        toggleInterFaceMenuItem.title = "Toggle interface (Current: " + proxy.getInterface() + ")"
        toggleInterFaceMenuItem.action = #selector(proxy.toggleInterface(_:))
        toggleInterFaceMenuItem.keyEquivalent = ""
        
        quitMenuItem.title = "Quit"
        quitMenuItem.action = #selector(AppDelegate.exitNow(_:))
        quitMenuItem.keyEquivalent = ""
        
        menu.addItem(toggleProxyMenuItem)
        menu.addItem(toggleSecureProxyMenuItem)
        menu.addItem(toggleInterFaceMenuItem)
        menu.addItem(quitMenuItem)
    }

}

