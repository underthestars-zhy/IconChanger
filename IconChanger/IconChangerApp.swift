//
//  IconChangerApp.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

@main
struct IconChangerApp: App {
    @StateObject var fullDiskPermision = FullDiskPermision.shared
    let updater = AutoUpdater()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: fullDiskPermision.hasPermision ? 750 : 500, minHeight: fullDiskPermision.hasPermision ? 500 : 300)
                .animation(.easeInOut, value: fullDiskPermision.hasPermision)
        }
        .commands { // Add Check for updates after AppInfo
            CommandGroup(after: .appInfo) {
                Button("Check for updates") {
                    updater.checkForUpdates()
                }
            }
        }

        Settings {
            SettingView()
        }
    }
}
