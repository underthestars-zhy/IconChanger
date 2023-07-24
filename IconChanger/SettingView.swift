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
            GeneralSettingView()
                    .tabItem {
                        Label("General", systemImage: "gearshape")
                    }
            APISettingView()
                    .tabItem {
                        Label("Api", systemImage: "bolt.fill")
                    }
        }
                .frame(width: 500, height: 400)
    }
}

struct GeneralSettingView: View {
    @State var aliasNames = AliasNames.getAll()
    @State private var selectedAlias = Set<AliasName.ID>()
    @State private var sortOrder = [KeyPathComparator(\AliasName.appName)]

    var body: some View {
        VStack {
            HStack {

                Text("Alias Names")
                        .font(.headline)
                Spacer()
                Button(action: {
                    let newAlias = AliasName(appName: "", aliasName: "")
                    aliasNames.append(newAlias)
                }) {
                    Image(systemName: "plus")
                }

                Button(action: {
                    guard let selectedID = selectedAlias.first, let selectedIndex = aliasNames.firstIndex(where: { $0.id == selectedID }) else {
                        return
                    }
                    aliasNames.remove(at: selectedIndex)
                    AliasNames.save(aliasNames)
                }) {
                    Image(systemName: "minus")
                }
                        .disabled(selectedAlias.isEmpty)
            }
                    .buttonStyle(.bordered)
            Table(aliasNames, selection: $selectedAlias, sortOrder: $sortOrder) {
                TableColumn("App Name", value: \.appName) { row in
                    TextField("App Name", text: Binding(
                            get: { row.appName },
                            set: { newValue in
                                if let index = aliasNames.firstIndex(where: { $0.id == row.id }) {
                                    aliasNames[index].appName = newValue
                                    AliasNames.save(aliasNames)
                                }
                            }
                    ))
                }
                TableColumn("Alias Name", value: \.aliasName) { row in
                    TextField("Alias Name", text: Binding(
                            get: { row.aliasName },
                            set: { newValue in
                                if let index = aliasNames.firstIndex(where: { $0.id == row.id }) {
                                    aliasNames[index].aliasName = newValue
                                    AliasNames.save(aliasNames)
                                }
                            }
                    ))
                }
            }
                    .onChange(of: sortOrder) {
                        aliasNames.sort(using: $0)
                    }

        }
                .padding()

    }
}


struct APISettingView: View {
    @AppStorage("queryHost") var queryHost: String = "p1txh7zfb3-3.algolianet.com"
    @State var text = ""

    var body: some View {
        Form {
            TextField("Query Host: ", text: $text)
                    .onChange(of: text) { newValue in
                        if newValue.isEmpty {
                            queryHost = "p1txh7zfb3-3.algolianet.com"
                        } else {
                            queryHost = text
                        }
                    }

            Spacer()
        }
                .padding()
    }
}
