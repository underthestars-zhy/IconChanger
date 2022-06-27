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

    func refresh() {
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

    func findSearchedImage(_ search: String) -> [LaunchPadManagerDBHelper.AppInfo] {
        apps.filter {
            $0.name.lowercased().contains(search.lowercased())
        }
    }

    func getIconInPath(_ url: String) -> [URL] {
        let url = URL(fileURLWithPath: url).appendingPathComponent("Contents").appendingPathComponent("Resources")
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
}

extension LaunchPadManagerDBHelper.AppInfo: Identifiable {
    public var id: URL {
        url
    }
}
