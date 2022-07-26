//
//  ChangeView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI
import LaunchPadManagerDBHelper

struct ChangeView: View {
    let rules = [GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top)]

    @State var icons: [URL] = []
    @State var inIcons: [URL] = []
    let setPath: LaunchPadManagerDBHelper.AppInfo

    @Environment(\.presentationMode) var presentationMode

    @StateObject var iconManager = IconManager.shared

    @State var importImage = false

    var body: some View {
        TabView {
            ScrollView(showsIndicators: false) {
                if icons.isEmpty {
                    VStack {
                        ProgressView()
                    }
                } else {
                    LazyVGrid(columns: rules) {
                        ForEach(icons, id: \.self) { icon in
                            ImageView(url: icon, setPath: setPath)
                        }

                        Spacer()
                    }
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

            ToolbarItem(placement: .automatic) {
                Button("Choose from local") {
                    importImage.toggle()
                }
            }
        }
        .frame(width: 500, height: 400)
        .onAppear {
            inIcons = iconManager.getIconInPath(setPath.url)
        }
        .task {
            do {
                icons = try await iconManager.getIcons(setPath)
                print(icons)
            } catch {
                print(error)
            }
        }
    }
}
