//
//  AliasNameCore.swift
//  IconChanger
//
//  Created by seril on 7/25/23.
//

import Foundation

struct AliasName: Identifiable {
    let id: String // Swift requires the `id` to conform to the `Identifiable` protocol
    var appName: String
    var aliasName: String // This property is now mutable

    init(appName: String, aliasName: String) {
        self.id = appName // We use `appName` as the `id` because it is unique
        self.appName = appName
        self.aliasName = aliasName
    }

    static func getName(for raw: String) -> String? {
        return AliasNames.getAll().first(where: { $0.appName == raw })?.aliasName
    }

    static func setName(_ name: String, for raw: String) {
        var aliases = AliasNames.getAll()
        if let index = aliases.firstIndex(where: { $0.appName == raw }) {
            aliases[index].aliasName = name
        } else {
            aliases.append(AliasName(appName: raw, aliasName: name))
        }
        AliasNames.save(aliases)
    }

    static func setEmpty(for raw: String) {
        var aliases = AliasNames.getAll()
        aliases.removeAll(where: { $0.appName == raw })
        AliasNames.save(aliases)
    }
}

struct AliasNames {
    static func getAll() -> [AliasName] {
        if let data = UserDefaults.standard.data(forKey: "AliasName") {
            let aliases = try? JSONDecoder().decode([String: String].self, from: data)
            return aliases?.map {
                AliasName(appName: $0.key, aliasName: $0.value)
            } ?? []
        }
        return []
    }

    static func save(_ aliasNames: [AliasName]) {
        let aliasDict = aliasNames.reduce(into: [String: String]()) {
            $0[$1.appName] = $1.aliasName
        }
        if let data = try? JSONEncoder().encode(aliasDict) {
            UserDefaults.standard.set(data, forKey: "AliasName")
        }
    }
}