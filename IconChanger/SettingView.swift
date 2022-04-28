//
//  SettingView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/28.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        TabView {
            APISettingView()
                .tabItem {
                    Label("Api", systemImage: "bolt.fill")
                }
        }
        .frame(width: 500, height: 400)
    }
}

struct APISettingView: View {
    @AppStorage("queryHost") var queryHost: String = ""

    var body: some View {
        Form {
            TextField("Query Host: ", text: $queryHost)

            Spacer()
        }
        .padding()
    }
}
