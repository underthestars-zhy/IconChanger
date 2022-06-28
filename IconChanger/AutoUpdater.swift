//
//  AutoUpdater.swift
//  SetAppX
//
//  Created by 朱浩宇 on 2021/3/14.
//

import Foundation
import Sparkle
import os

class AutoUpdater: NSObject {

    // Using the SPUStandardUserDriver
    let userDriver: SPUUserDriver = SPUStandardUserDriver(hostBundle: Bundle.main, delegate: nil)

    let updater: SPUUpdater?


    override init() {

        // Create SPUUpdater instance and hook it up to Bundle.main
        // and userDriver
        self.updater = SPUUpdater(
            hostBundle: Bundle.main, applicationBundle: Bundle.main, userDriver: userDriver, delegate: nil)
        do {
            try self.updater?.start()
        } catch {
            Logger().error("Failed to SPUUpdater")
        }
    }


    func checkForUpdates() {
        guard let updater = updater else {
            Logger().error("updater was nil")
            return
        }
        Logger().info("Checking for updates at \(updater.feedURL)")
        updater.checkForUpdates()
    }

}
