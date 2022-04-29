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

            OtherFolderView()
                .tabItem {
                    Label("Addition", systemImage: "folder.fill")
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

struct OtherFolderView: View {
    @State var add = false
    @State var folders = UserDefaults.standard.object(forKey: "addition") as? [URL] ?? [URL]()

    var body: some View {
        VStack {
            List {
                ForEach(folders, id: \.self) { url in
                    Text(url.path)
                }
            }
            .padding()

            HStack {
                Button("Add") {
                    add.toggle()
                }

                Spacer()
            }
            .padding()
        }
        .padding()
        .fileImporter(isPresented: $add, allowedContentTypes: [.folder]) { result in
            switch result{
            case .success(let url):
                if let data = UserDefaults.standard.data(forKey: "addition"), var folders = try? JSONDecoder().decode([URL].self, from: data) {
                    folders.append(url)
                    UserDefaults.standard.set(folders, forKey: "addition")
                    self.folders = folders
                } else {
                    var folders = [URL]()
                    folders.append(url)
                    UserDefaults.standard.set(try? JSONEncoder().encode(folders), forKey: "addition")
                    self.folders = folders
                }
                IconManager.shared.addition()
            case .failure(let error):
                print(error)
            }
        }
    }
}
