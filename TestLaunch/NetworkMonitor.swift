//
//  NetworkMonitor.swift
//  TestLaunch
//
//  Created by Rudolf Farkas on 31.03.20.
//  Copyright © 2020 Rudolf Farkas. All rights reserved.
//

import Network // @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)

// see https://www.hackingwithswift.com/example-code/networking/how-to-check-for-internet-connectivity-using-nwpathmonitor

/**
    NetworkMonitor.shared usage:

    1. get the current state when you need it
        print(NetworkMonitor.shared.connected ? "is connected" : "is disconnected"

    2. add a callback to get a notification when the connectivity changed
        NetworkMonitor.shared.callback = { isConnected in
            print(isConnected ? "is connected" : "is disconnected")
        }
 */
class NetworkMonitor {
    static var shared = NetworkMonitor()
    private var monitor = NWPathMonitor()
    private(set) var connected = false

    var callback: ((Bool) -> Void)?

    func networkStatus() {
        monitor.pathUpdateHandler = { path in
            self.connected = (path.status == .satisfied)
           if let callback = self.callback {
                callback(self.connected)
            }
            print(self.connected ? "connected!" : "disconnected!")
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    private init() {
        networkStatus()
    }
}
