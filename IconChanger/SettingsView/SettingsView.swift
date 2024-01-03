//
//  SettingView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/28.
//  Modified by seril on 2023/7/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        TabView {
//            GeneralSettingsView()
//                    .tabItem {
//                        Label("General", systemImage: "gearshape")
//                    }
            ApplicationSettingsView()
                    .tabItem {
                        Label("Application", systemImage: "app")
                    }
            APISettingsView()
                    .tabItem {
                        Label("Api", systemImage: "bolt")
                    }
        }
                .padding()
                .frame(width: 500, height: 400)
    }
}


