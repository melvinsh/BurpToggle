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

    @IBOutlet weak var window: NSWindow!
    
    var statusBar = NSStatusBar.systemStatusBar()
    var statusBarItem : NSStatusItem = NSStatusItem()
    
    var menu: NSMenu = NSMenu()
    var toggleMenuItem : NSMenuItem = NSMenuItem()
    var toggleMenuItem2 : NSMenuItem = NSMenuItem()
    var toggleMenuItem3 : NSMenuItem = NSMenuItem()
    var quitMenuItem : NSMenuItem = NSMenuItem()
    
    var interface = "Wi-Fi"
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    func toggleInterface(sender: AnyObject)
    {
        if(interface == "Wi-Fi") {
            interface = "Ethernet"
        }
        else if(interface == "Ethernet") {
            interface = "USB\\ Ethernet"
        }
        else {
            interface = "Wi-Fi"
        }
        
        setProxyStatusMenu()
        setSecureProxyStatusMenu()
        
        toggleMenuItem3.title = "Toggle interface (Current: " + interface + ")"
    }
    
    func getProxyStatus() -> Int {
        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "networksetup -getwebproxy " + interface + " | grep Yes"]
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        return output.length
    }
    
    func getSecureProxyStatus() -> Int {
        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "networksetup -getsecurewebproxy " + interface + " | grep Yes"]
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)!
        
        return output.length
    }
    
    func toggleProxy(sender: AnyObject) {
        if(getProxyStatus() ==  13) {
            system("networksetup -setwebproxystate " + interface + " off");
            toggleMenuItem.title = "Enable HTTP Proxy"
        } else {
            system("networksetup -setwebproxy " + interface + " localhost 8080");
            toggleMenuItem.title = "Disable HTTP Proxy"
        }
    }
    
    func toggleSecureProxy(sender: AnyObject) {
        if(getSecureProxyStatus() ==  13) {
            system("networksetup -setsecurewebproxystate " + interface + " off");
            toggleMenuItem2.title = "Enable HTTPS Proxy"
        } else {
            system("networksetup -setsecurewebproxy " + interface + " localhost 8080");
            toggleMenuItem2.title = "Disable HTTPS Proxy"
        }
    }
    
    func setProxyStatusMenu() {
        if(getProxyStatus() == 13) {
            toggleMenuItem.title = "Disable HTTP Proxy"
        } else {
            toggleMenuItem.title = "Enable HTTP Proxy"
        }
    }
    
    func setSecureProxyStatusMenu() {
        if(getSecureProxyStatus() == 13) {
            toggleMenuItem2.title = "Disable HTTPS Proxy"
        } else {
            toggleMenuItem2.title = "Enable HTTPS Proxy"
        }
    }
    
    func exitNow(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    
    override func awakeFromNib() {
        statusBarItem = statusBar.statusItemWithLength(-1)
        statusBarItem.menu = menu
        statusBarItem.title = "B"
        
        setProxyStatusMenu()
        
        toggleMenuItem.action = Selector("toggleProxy:")
        toggleMenuItem.keyEquivalent = ""
        
        setSecureProxyStatusMenu()
        
        toggleMenuItem2.action = Selector("toggleSecureProxy:")
        toggleMenuItem2.keyEquivalent = ""
        
        toggleMenuItem3.title = "Toggle interface (Current: " + interface + ")"
        toggleMenuItem3.action = Selector("toggleInterface:")
        toggleMenuItem3.keyEquivalent = ""
        
        quitMenuItem.title = "Quit"
        quitMenuItem.action = Selector("exitNow:")
        quitMenuItem.keyEquivalent = ""
        
        menu.addItem(toggleMenuItem)
        menu.addItem(toggleMenuItem2)
        menu.addItem(toggleMenuItem3)
        menu.addItem(quitMenuItem)
    }

}

