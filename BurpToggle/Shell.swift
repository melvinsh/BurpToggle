//
//  Shell.swift
//  BurpToggle
//
//  Created by Melvin on 16/09/2016.
//  Copyright © 2016 Melvin Lammerts. All rights reserved.
//

import Cocoa

class Shell: NSObject {
    static func run(args: String...) {
        let task = Process()
        task.launchPath = "/bin/bash"
        let foo = ["-c"] + args
        task.arguments = foo
        task.launch()
        task.waitUntilExit()
    }
}
