//
//  IconManager.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI
import SwiftyJSON

class IconManager: ObservableObject {
    static let shared = IconManager()

    var icons = [(String, String)]()
    var apps: [String] = []

    @Published var load = true

    init() {
        let applicationURL = URL(fileURLWithPath: "//Applications")

        apps = (try? FileManager.default.contentsOfDirectory(atPath: applicationURL.path).filter {
            $0.first != "."
        }.map {
            applicationURL.appendingPathComponent($0).path
        }) ?? []

        Task {
            guard let url = Bundle.main.url(forResource: "icons.json", withExtension: nil) else {
                return
            }

            let data = try Data(contentsOf: url)

            let json = try JSON(data: data)

            for icon in json.arrayValue {
                icons.append((getNameFromURL(icon.stringValue), icon.stringValue))
            }
            load = false
        }
    }

    func findSearchedImage(_ search: String) -> [String] {
        apps.filter {
            $0.lowercased().contains(search.lowercased())
        }
    }

    func findRelated(_ url: String) -> [URL] {
        let name = getAppName(url)
        var res = Set<URL>()

        for icon in icons {
            if icon.0.lowercased().contains(name.lowercased()) {
                if let url = URL(string: icon.1) {
                    res.insert(url)
                }
            }
        }

        return getIconInPath(url) + res.map { $0 }
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

    func getAppName(_ url: String) -> String {
        ((url as NSString).deletingPathExtension as NSString).lastPathComponent
    }

    func getNameFromURL(_ url: String) -> String {
        let count = "https://media.macosicons.com/parse/files/macOSicons/81c998bdc590f1d6998187d39f6ea1d2".count
        let endCount = url.count - ".icns".count

        return String(url[count..<endCount] ?? "")
    }
}
