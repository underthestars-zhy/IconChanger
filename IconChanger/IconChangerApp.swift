//
//  IconChangerApp.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI
import Sparkle

@main
struct IconChangerApp: App {
    @StateObject var fullDiskPermision = FullDiskPermision.shared
    private let updaterController: SPUStandardUpdaterController

    init() {
        // If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
        // This is where you can also pass an updater delegate if you need one
        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: fullDiskPermision.hasPermision ? 750 : 500, minHeight: fullDiskPermision.hasPermision ? 500 : 300)
                .animation(.easeInOut, value: fullDiskPermision.hasPermision)
        }
        .commands {
            CommandGroup(after: .appInfo) {
                CheckForUpdatesView(updater: updaterController.updater)
            }
        }
        
        Settings {
            SettingView()
        }
    }
}
