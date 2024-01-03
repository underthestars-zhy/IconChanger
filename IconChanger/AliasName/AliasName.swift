//
//  AliasName.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/27.
//

import SwiftUI

struct AliasNameOld {
    static let names = [
        "wechatwebdevtools": "wechat dev",
        "WebStorm Early Access Program": "WebStorm",
        "PyCharm Professional Edition": "PyCharm",
        "语雀": "yuque",
        "System Settings": "Settings",
        "Readwise_iBooks": "Readwise",
        "Adobe Photoshop (Beta)": "Photoshop",
        "Adobe Bridge (Beta)": "Bridge",
        "Adobe Illustrator (Beta)": "Illustrator",
        "Adobe Illustrator 2023": "Illustrator",
        "PyCharm Community": "PyCharm",
    ]

    static func getNames() -> [String: String] {
        if let data = UserDefaults.standard.data(forKey: "AliasName") {
            return names + ((try? JSONDecoder().decode([String: String].self, from: data)) ?? [:])
        }

        return names
    }

    static func getNames(for raw: String) -> String? {
        return getNames()[raw]
    }

    static func setName(_ name: String, for raw: String) {
        do {
            if let data = UserDefaults.standard.data(forKey: "AliasName"), var names = try? JSONDecoder().decode([String: String].self, from: data) {
                names[raw] = name
                UserDefaults.standard.set(try JSONEncoder().encode(names), forKey: "AliasName")
            } else {
                UserDefaults.standard.set(try JSONEncoder().encode([raw: name]), forKey: "AliasName")
            }
        } catch {
            print(error)
        }

        UserDefaults.standard.synchronize()
    }

    static func setEmpty(for raw: String) {
        do {
            if let data = UserDefaults.standard.data(forKey: "AliasName"), var names = try? JSONDecoder().decode([String: String].self, from: data) {
                names[raw] = nil
                UserDefaults.standard.set(try JSONEncoder().encode(names), forKey: "AliasName")
            }
        } catch {
            print(error)
        }

        UserDefaults.standard.synchronize()
    }
}

extension Dictionary {
    static func +(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs
        for (key, value) in rhs {
            lhs[key] = value
        }
        return lhs
    }
}
