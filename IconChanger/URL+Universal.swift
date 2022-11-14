//
//  URL+Universal.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/26.
//

import Foundation

extension URL {
    func universalappending(path: String) -> Self {
        return self.appendingPathComponent(path)
    }

    func universalPath() -> String {
        return self.path.removingPercentEncoding ?? self.path
    }

    init(universalFilePath: String) {
        self.init(fileURLWithPath: universalFilePath)
    }
}
