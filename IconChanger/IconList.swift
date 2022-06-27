//
//  IconList.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI
import LaunchPadManagerDBHelper

struct IconList: View {
    @StateObject var iconManager = IconManager.shared

    let rules = [GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top)]

    @State var setPath: LaunchPadManagerDBHelper.AppInfo? = nil

    @State var searchText: String = ""
    @State var setAlias: String?

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: rules) {
                if !searchText.isEmpty {
                    ForEach(iconManager.findSearchedImage(searchText), id: \.url) { app in
                        VStack {
                            Button {
                                setPath = app
                            } label: {
                                Image(nsImage: NSWorkspace.shared.icon(forFile: app.url.universalPath()))
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.bottom)
                            }
                            .buttonStyle(BorderlessButtonStyle())

                            Text(app.name)
                                .multilineTextAlignment(.center)
                        }
                        .contextMenu {
                            Button("Copy path") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(app.url.universalPath(), forType: .string)
                            }

                            Button("Copy URL App Name") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(app.url.deletingPathExtension().lastPathComponent, forType: .string)
                            }

                            Button("Set Alias") {
                                setAlias = app.url.deletingPathExtension().lastPathComponent
                            }
                        }
                        .padding()
                    }
                } else {
                    ForEach(iconManager.apps, id: \.url) { app in
                        VStack {
                            Button {
                                setPath = app
                            } label: {
                                Image(nsImage: NSWorkspace.shared.icon(forFile: app.url.universalPath()))
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.bottom)
                            }
                            .buttonStyle(BorderlessButtonStyle())

                            Text(app.name)
                                .multilineTextAlignment(.center)
                        }
                        .contextMenu {
                            Button("Copy path") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(app.url.universalPath(), forType: .string)
                            }

                            Button("Copy URL App Name") {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(app.url.deletingPathExtension().lastPathComponent, forType: .string)
                            }

                            Button("Set Alias") {
                                setAlias = app.url.deletingPathExtension().lastPathComponent
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .sheet(item: $setAlias) {
            SetAliasNameView(raw: $0, lastText: AliasName.getNames(for: $0) ?? "")
        }
        .sheet(item: $setPath) {
            ChangeView(setPath: $0)
                .onDisappear {
                    setPath = nil
                }
        }
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    iconManager.refresh()
                } label: {
                    Image(systemName: "goforward")
                }

            }
        }
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
