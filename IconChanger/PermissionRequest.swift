//
//  PermisionRequest.swift
//  IconChanger
//
//  Created by seril on 7/25/23.
//

import SwiftUI
import Combine

class FolderPermission: ObservableObject {
    static let shared = FolderPermission()

    @Published var hasPermission: Bool = false
    var bookmarkData: Data? {
        didSet {
            UserDefaults.standard.set(bookmarkData, forKey: "bookmarkData")
        }
    }
    var url: URL?

    init() {
        if let bookmarkData = UserDefaults.standard.data(forKey: "bookmarkData") {
            self.bookmarkData = bookmarkData
            do {
                let url = try accessBookmark(bookmarkData)
                self.url = url
                hasPermission = true
            } catch {
                print("Error accessing bookmark:", error)
                hasPermission = false
            }
        }
    }

    func check() {
        let openPanel = NSOpenPanel()
        openPanel.directoryURL = URL(fileURLWithPath: "/Applications")
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.begin { (result) in
            if result == .OK {
                guard let url = openPanel.url else { return }
                self.url = url
                do {
                    let bookmark = try self.createBookmark(from: url)
                    self.bookmarkData = bookmark
                    self.hasPermission = true
                } catch {
                    print("Error creating bookmark:", error)
                    self.hasPermission = false
                }
            } else {
                self.hasPermission = false
            }
        }
    }

    // 创建一个安全标签
    func createBookmark(from url: URL) throws -> Data {
        let bookmarkData = try url.bookmarkData(options: .withSecurityScope,
                includingResourceValuesForKeys: nil,
                relativeTo: nil)
        return bookmarkData
    }

    // 使用一个安全标签
    func accessBookmark(_ bookmarkData: Data) throws -> URL {
        var isStale = false
        let bookmarkedURL = try URL(resolvingBookmarkData: bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale)

        if isStale {
            // 书签数据已经过时，需要重新创建
            // ...
        }

        if !bookmarkedURL.startAccessingSecurityScopedResource() {
            // 没有权限访问资源
            // ...
        }

        return bookmarkedURL
    }
}
