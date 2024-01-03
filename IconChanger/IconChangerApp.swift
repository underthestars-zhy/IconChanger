//
//  IconChangerApp.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//  Modified by seril on 2023/7/25.
//

import SwiftUI
import Sparkle

@main
struct IconChangerApp: App {
//    @StateObject var fullDiskPermision = FullDiskPermision.shared
    @StateObject var folderPermission = FolderPermission.shared
    private let updaterController: SPUStandardUpdaterController

    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
        setupDefaultAliasNames()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                    .frame(minWidth: folderPermission.hasPermission ? 900 : 500, minHeight: folderPermission.hasPermission ? 500 : 300)
                    .animation(.easeInOut, value: folderPermission.hasPermission)
        }
                .commands {
                    CommandGroup(after: .appInfo) {
                        CheckForUpdatesView(updater: updaterController.updater)
                    }
                }

        Settings {
            SettingsView()
        }
    }
}
