//
//  IconManager.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI
import SwiftyJSON
import LaunchPadManagerDBHelper

class IconManager: ObservableObject {
    static let shared = IconManager()

    @Published var icons = [(String, String)]()
    @Published var apps: [LaunchPadManagerDBHelper.AppInfo] = []

    @Published var load = true

    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refresh), name: NSWindow.didBecomeKeyNotification, object: nil)

        Task {
            do {
                let helper = try LaunchPadManagerDBHelper()

                apps = try helper.getAllAppInfos()

                load = false
            } catch {
                print(error)
            }
        }
    }

    @objc func refresh() {
        Task {
            load = false
            
            do {
                let helper = try LaunchPadManagerDBHelper()

                apps = try helper.getAllAppInfos()

                load = false
            } catch {
                print(error)
            }
        }
    }

    func installHelperTool() throws {
        print(URL.documents)
        guard let shBundlePath = Bundle.main.path(forResource: "chmodHelper", ofType: "sh") else { fatalError("Cannot get the sh file path") }
        try FileManager.default.copyItem(atPath: shBundlePath, toPath: URL.documents.universalappending(path: "chmodHelper.sh").universalPath())
        NSAppleScript(source: "do shell script \"sudo chmod 777 '\(URL.documents.universalappending(path: "chmodHelper.sh").universalPath())'\" with administrator " + "privileges")!.executeAndReturnError(nil)
    }

    func setHelperToolContent(path: String) throws {
        let helperToolURL = URL.documents.universalappending(path: "chmodHelper.sh")
        var content = try String(contentsOf: helperToolURL, encoding: .utf8)

        if #available(macOS 13.0, *) {
            content.replace("%path", with: path)
        } else {
            content = content.replace(target: "%path", withString: path)
        }

        try content.write(to: helperToolURL, atomically: true, encoding: .utf8)
    }

    func findSearchedImage(_ search: String) -> [LaunchPadManagerDBHelper.AppInfo] {
        apps.filter {
            $0.name.lowercased().contains(search.lowercased())
        }
    }

    func getIconInPath(_ url: URL) -> [URL] {
        let url = url.appendingPathComponent("Contents").appendingPathComponent("Resources")
        let file = (try? FileManager.default.contentsOfDirectory(atPath: url.path)) ?? [String]()
        return file.filter {
            $0.contains(".icns")
        }.map {
            url.appendingPathComponent($0).path
        }.map {
            URL(fileURLWithPath: $0)
        }
    }

    func getNameFromURL(_ url: String) -> String {
        let count = "https://media.macosicons.com/parse/files/macOSicons/81c998bdc590f1d6998187d39f6ea1d2".count
        let endCount = url.count - ".icns".count

        return String(url[count..<endCount] ?? "")
    }

    func getIcons(_ app: LaunchPadManagerDBHelper.AppInfo) async throws -> [URL] {
        let appName = app.name
        let urlName = AliasName.getNames(for: app.url.deletingPathExtension().lastPathComponent) ?? app.url.deletingPathExtension().lastPathComponent
        let bundleName = try getAppBundleName(app)

        var urls = [URL]()

        urls.append(contentsOf: try await MyQueryRequestController().sendRequest(appName))
        urls.append(contentsOf: try await MyQueryRequestController().sendRequest(urlName))
        if let bundleName {
            urls.append(contentsOf: try await MyQueryRequestController().sendRequest(bundleName))
        }

        return Set(urls).map { $0 }
    }

    func getAppBundleName(_ app: LaunchPadManagerDBHelper.AppInfo) throws -> String? {
        let plistURL = app.url.universalappending(path: "Contents").universalappending(path: "Info.plist")
        let plist = (try NSDictionary(contentsOf: plistURL, error: ())) as? Dictionary<String, AnyObject>

        return (plist?["CFBundleDisplayName"] as? String) ?? (plist?["CFBundleName"] as? String)
    }

    func runHelperTool() throws {
        let helperToolURL = URL.documents.universalappending(path: "chmodHelper.sh")
        try Self.safeShell("./\(helperToolURL.universalPath())")
    }

    @discardableResult
    static func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        try task.run()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!

        return output
    }
}

extension LaunchPadManagerDBHelper.AppInfo: Identifiable {
    public var id: URL {
        url
    }
}

extension String {
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}
