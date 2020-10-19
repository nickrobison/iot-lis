//
//  AppDelegate.swift
//  LISTester
//
//  Created by Nicholas Robison on 10/18/20.
//

import Cocoa
import LISKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    var btm: BluetoothManager?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        btm = BluetoothManager()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

