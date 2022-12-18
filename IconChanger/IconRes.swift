//
//  IconRes.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/12/18.
//

import Foundation

struct IconRes: Hashable {
    let appName: String
    let icnsUrl: URL
    let lowResPngUrl: URL
    let downloads: Int
}
