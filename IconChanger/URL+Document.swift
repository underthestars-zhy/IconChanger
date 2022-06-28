//
//  URL+Document.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/28.
//

import Foundation

extension URL {
    static var documents: URL {
        let path = "\(NSHomeDirectory())/.iconchanger/data/helper"
        let url = URL(universalFilePath: path)
        if !FileManager.default.fileExists(atPath: path) {
            try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }

        return url
    }
}
