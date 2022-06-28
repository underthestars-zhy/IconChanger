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
            Group {
                if iconManager.load {
                    ProgressView()
                        .searchable(text: .constant(""))
                } else {
                    IconList()
                }
            }
        } else {
            VStack {
                Text("We Need Full Disk Access")
                    .font(.largeTitle.bold())
                    .padding()

                VStack(alignment: .leading) {
                    Text("1. Open Setting App")
                    Text("2. Go to security")
                    Text("3. Choose Full Disk Access")
                    Text("4. Unlock")
                    Text("5. Choose or add IconChanger")
                    Text("6. Check th check box")
                }
                .multilineTextAlignment(.leading)

                Button("Check Access") {
                    fullDiskPermision.check()
                }
                .padding()
            }
            .task {
                if #available(macOS 13.0, *) {
                    try? await Task.sleep(until: .now + .seconds(1), clock: .suspending)
                }
                fullDiskPermision.check()
                if !fullDiskPermision.hasPermision {
                    NSWorkspace.shared.openLocationService(for: .fullDisk)
                }
            }
            .task {
                if helperToolVersion < Config.helperToolVersion {
                    if #available(macOS 13.0, *) {
                        try? await Task.sleep(until: .now + .seconds(1), clock: .suspending)
                    }
                    
                    do {
                        try iconManager.installHelperTool()
                        helperToolVersion = Config.helperToolVersion
                    } catch {
                        fatalError(error.localizedDescription)
                    }
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
