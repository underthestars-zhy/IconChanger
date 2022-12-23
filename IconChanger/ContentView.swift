//
//  ContentView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fullDiskPermision = FullDiskPermision.shared
    @StateObject var iconManager = IconManager.shared
    @AppStorage("helperToolVersion") var helperToolVersion = 0
    
    var body: some View {
        if fullDiskPermision.hasPermision {
            IconList()
                .task {
                    if helperToolVersion < Config.helperToolVersion {
                        if #available(macOS 13.0, *) {
                            try? await Task.sleep(until: .now + .seconds(1), clock: .suspending)
                        } else {
                            try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                        }

                        do {
                            try iconManager.installHelperTool()
                            helperToolVersion = Config.helperToolVersion
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                }
        } else {
            VStack {
                Text("We Need Full Disk Access")
                    .font(.largeTitle.bold())
                    .padding()

                VStack(alignment: .leading) {
                    Text("1. Open the System Setting App")
                    Text("2. Go to the security")
                    Text("3. Choose the Full Disk Access")
                    Text("4. Unlock it")
                    Text("5. Choose or add the IconChanger")
                    Text("6. Check the check box")
                }
                .multilineTextAlignment(.leading)

                Button("Check the Access Permition") {
                    fullDiskPermision.check()
                }
                .padding()
            }
            .task {
                if #available(macOS 13.0, *) {
                    try? await Task.sleep(for: .seconds(1))
                } else {
                    try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                }

                fullDiskPermision.check()
                if !fullDiskPermision.hasPermision {
                    NSWorkspace.shared.openLocationService(for: .fullDisk)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension NSWorkspace {

    enum SystemServiceType: String {
        case privacy = "x-apple.systempreferences:com.apple.preference.security?Privacy"
        case camera = "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera"
        case microphone = "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
        case location = "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices"
        case contacts = "x-apple.systempreferences:com.apple.preference.security?Privacy_Contacts"
        case calendars = "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"
        case reminders = "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
        case photos = "x-apple.systempreferences:com.apple.preference.security?Privacy_Photos"
        case fullDisk = "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"
    }

    func openLocationService(for type: SystemServiceType) {
        let url = URL(string: type.rawValue)!
        NSWorkspace.shared.open(url)
    }
}
