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

    init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(refresh), name: NSWindow.didBecomeKeyNotification, object: nil)

        do {
            let helper = try LaunchPadManagerDBHelper()

            apps = try helper.getAllAppInfos().sorted(by: { info1, info2 in
                info1.name.compare(info2.name) == .orderedAscending
            })

        } catch {
            print(error)
        }
    }

    @objc func refresh() {
        do {
            let helper = try LaunchPadManagerDBHelper()

            apps = try helper.getAllAppInfos().sorted(by: { info1, info2 in
                info1.name.compare(info2.name) == .orderedAscending
            })
        } catch {
            print(error)
        }
    }

    func installHelperTool() throws {
        let data=Data(bytes: HelperInstallerBytesArray, count: HelperInstallerBytesArray.count)
        let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
        let installHelperURL = temporaryDirectoryURL.appendingPathComponent("\(NSUUID().uuidString).sh")
        
        try data.write(to: installHelperURL)
        
        let installHelperPath:String
        if #available(macOS 13.0, *) {
            installHelperPath=installHelperURL.path(percentEncoded: false)
        } else {
            installHelperPath=installHelperURL.path
        }
        let helperDirectoryPath=URL.documents.universalPath()
        NSAppleScript(source: "do shell script \"chmod +x '\(installHelperPath)' &&  '\(installHelperPath)' '\(helperDirectoryPath)' ; rm '\(installHelperPath)' \" with administrator privileges")!.executeAndReturnError(nil)
    
        
    }

    static func saveImage(_ image: NSImage, atUrl url: URL) {
        guard
            let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        else { return } // TODO: handle error
        let newRep = NSBitmapImageRep(cgImage: cgImage)
        newRep.size = image.size // if you want the same size
        guard
            let pngData = newRep.representation(using: .png, properties: [:])
        else { return } // TODO: handle error
        do {
            try pngData.write(to: url)
        }
        catch {
            print("error saving: \(error)")
        }
    }

    func setImage(_ image: NSImage, app: LaunchPadManagerDBHelper.AppInfo) throws {
        let imageURL=FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!.universalappending(path: "IconChanger.png")
        
#if DEBUG
        print(imageURL)
#endif

        if FileManager.default.fileExists(atPath: imageURL.universalPath()) {
            try FileManager.default.removeItem(at: imageURL)
        }

        Self.saveImage(image, atUrl: imageURL)

        try runHelperTool(appPath: app.url.universalPath(), imagePath: imageURL.universalPath())
    }

    func findSearchedImage(_ search: String) -> [LaunchPadManagerDBHelper.AppInfo] {
        apps.filter {
            $0.name.lowercased().contains(search.lowercased()) || $0.url.deletingPathExtension().lastPathComponent.lowercased().contains(search.lowercased())
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

    func getIcons(_ app: LaunchPadManagerDBHelper.AppInfo) async throws -> [IconRes] {
        let appName = app.name
        let urlName = app.url.deletingPathExtension().lastPathComponent
        let bundleName = try getAppBundleName(app)
        let aliasName = AliasName.getNames(for: app.url.deletingPathExtension().lastPathComponent)

        var res = [IconRes]()

        res.append(contentsOf: try await MyQueryRequestController().sendRequest(appName))
        res.append(contentsOf: try await MyQueryRequestController().sendRequest(urlName))
        
        if let bundleName {
            res.append(contentsOf: try await MyQueryRequestController().sendRequest(bundleName))
        }

        if let aliasName {
            res.append(contentsOf: try await MyQueryRequestController().sendRequest(aliasName))
        }

        return Set(res).map { $0 }
    }

    func getAppBundleName(_ app: LaunchPadManagerDBHelper.AppInfo) throws -> String? {
        let plistURL = app.url.universalappending(path: "Contents").universalappending(path: "Info.plist")
        let plist = (try? NSDictionary(contentsOf: plistURL, error: ())) as? Dictionary<String, AnyObject>

        return (plist?["CFBundleDisplayName"] as? String) ?? (plist?["CFBundleName"] as? String)
    }

    func runHelperTool(appPath: String,imagePath: String) throws {
        let helperToolURL = URL.documents.universalappending(path: "helper.sh")
        try Self.safeShell("sudo '\(helperToolURL.universalPath())' '\(appPath)' '\(imagePath)'")
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
