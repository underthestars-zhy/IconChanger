//
//  FullDiskPermision.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

class FullDiskPermision: ObservableObject {
    static let shared = FullDiskPermision()

    @Published var hasPermision: Bool = true

    init() {
        hasPermision = UserDefaults.standard.bool(forKey: "FullDisk")
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: NSWindow.didBecomeKeyNotification, object: nil)
    }

    @objc func appMovedToBackground() {
        check()
    }

    func check() {
        let url = URL(fileURLWithPath: "/Library/Application Support/com.apple.TCC/TCC.db")

        do {
            hasPermision = !(try Data(contentsOf: url).isEmpty)
        } catch {
#if DEBUG
            print(error)
#endif
            hasPermision = false
        }
    }
}
