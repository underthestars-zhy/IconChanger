//
//  URL+Universal.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/26.
//

import Foundation

extension URL {
    func universalappending(path: String) -> Self {
        if #available(macOS 13, *) {
            return self.appending(component: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }

    func universalPath() -> String {
        if #available(macOS 13, *) {
            return self.path().removingPercentEncoding ?? self.path()
        } else {
            return self.path.removingPercentEncoding ?? self.path
        }
    }

    init(universalFilePath: String) {
        if #available(macOS 13, *) {
            self.init(filePath: universalFilePath)
        } else {
            self.init(fileURLWithPath: universalFilePath)
        }
    }
}
