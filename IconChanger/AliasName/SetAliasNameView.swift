//
//  SetAliasNameView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/27.
//  Modified by seril on 2023/7/25.
//

import SwiftUI

struct SetAliasNameView: View {
    let raw: String
    let lastText: String
    @State var text = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField(raw, text: $text)
                    .frame(width: 350)
                    .padding()
        }
                .onAppear {
                    if !lastText.isEmpty && lastText != raw {
                        text = lastText
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Finish") {
                            if text.isEmpty {
                                AliasName.setEmpty(for: raw)
                            } else {
                                AliasName.setName(text, for: raw)
                            }

                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
    }
}

func setupDefaultAliasNames() {
    let defaultAlias = [
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

    if let data = UserDefaults.standard.data(forKey: "AliasName"),
       var storedAlias = try? JSONDecoder().decode([String: String].self, from: data) {

        for (key, value) in defaultAlias {
            if storedAlias[key] == nil {
                storedAlias[key] = value
            }
        }
        UserDefaults.standard.set(try? JSONEncoder().encode(storedAlias), forKey: "AliasName")
    } else {
        UserDefaults.standard.set(try? JSONEncoder().encode(defaultAlias), forKey: "AliasName")
    }
}