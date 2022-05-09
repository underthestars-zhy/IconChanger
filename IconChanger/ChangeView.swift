//
//  ChangeView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

struct ChangeView: View {
    let rules = [GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top)]

    @State var icons: [URL] = []
    @State var inIcons: [URL] = []
    let setPath: String

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        TabView {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: rules) {
                    ForEach(icons, id: \.self) { icon in
                        ImageView(url: icon, setPath: setPath)
                    }

                    Spacer()
                }
            }
            .tabItem {
                Text("macOSIcon")
            }

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: rules) {
                    ForEach(inIcons, id: \.self) { icon in
                        ImageView(url: icon, setPath: setPath)
                    }

                    Spacer()
                }
            }
            .tabItem {
                Text("Local")
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .frame(width: 500, height: 400)
        .task {
            inIcons = IconManager.shared.getIconInPath(setPath)
            let name = IconManager.shared.getAppName(setPath)
            do {
                icons = try await MyQueryRequestController().sendRequest(name)
            } catch {
                print(error)
            }
        }
    }
}
