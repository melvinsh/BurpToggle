//
//  Proxy.swift
//  BurpToggle
//
//  Created by Melvin on 16/09/2016.
//  Copyright © 2016 Melvin Lammerts. All rights reserved.
//

import Cocoa

class Proxy: NSObject {
    var interface = "Wi-Fi"
    
    var proxymenu: NSMenuItem
    var secureproxymenu: NSMenuItem
    var interfacemenu: NSMenuItem
    
    init(items: [NSMenuItem]) {
        proxymenu = items[0]
        secureproxymenu = items[1]
        interfacemenu = items[2]
    }
    
    func getInterface() -> String {
        return interface;
    }
    
    func toggleInterface(_ sender: AnyObject)
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
        
        interfacemenu.title = "Toggle interface (Current: " + interface + ")"
    }
    
    func getProxyStatus() -> Int {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "networksetup -getwebproxy " + interface + " | grep Yes"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        
        return output.length
    }
    
    func getSecureProxyStatus() -> Int {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", "networksetup -getsecurewebproxy " + interface + " | grep Yes"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        
        return output.length
    }
    
    func toggleProxy(_ sender: AnyObject) {
        if(getProxyStatus() ==  13) {
            Shell.run(args: "networksetup -setwebproxystate " + interface + " off");
            proxymenu.title = "Enable HTTP Proxy"
        } else {
            Shell.run(args: "networksetup -setwebproxy " + interface + " localhost 8080");
            proxymenu.title = "Disable HTTP Proxy"
        }
    }
    
    func toggleSecureProxy(_ sender: AnyObject) {
        if(getSecureProxyStatus() ==  13) {
            Shell.run(args: "networksetup -setsecurewebproxystate " + interface + " off");
            secureproxymenu.title = "Enable HTTPS Proxy"
        } else {
            Shell.run(args: "networksetup -setsecurewebproxy " + interface + " localhost 8080");
            secureproxymenu.title = "Disable HTTPS Proxy"
        }
    }
    
    func setProxyStatusMenu() {
        if(getProxyStatus() == 13) {
            proxymenu.title = "Disable HTTP Proxy"
        } else {
            proxymenu.title = "Enable HTTP Proxy"
        }
    }
    
    func setSecureProxyStatusMenu() {
        if(getSecureProxyStatus() == 13) {
            secureproxymenu.title = "Disable HTTPS Proxy"
        } else {
            secureproxymenu.title = "Enable HTTPS Proxy"
        }
    }
}
