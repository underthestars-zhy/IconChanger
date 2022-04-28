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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: fullDiskPermision.hasPermision ? 750 : 500, minHeight: fullDiskPermision.hasPermision ? 500 : 300)
                .animation(.easeInOut, value: fullDiskPermision.hasPermision)
        }
    }
}
