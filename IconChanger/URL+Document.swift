//
//  URL+Document.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/28.
//

import Foundation

extension URL {
    static var documents: URL {
        let path = FileManager.default.urls(
            for: FileManager.SearchPathDirectory.applicationSupportDirectory,
            in: FileManager.SearchPathDomainMask.systemDomainMask)
            .first!.universalappending(path: "IconChanger").universalPath()
        let url = URL(universalFilePath: path)

        return url
    }
}
