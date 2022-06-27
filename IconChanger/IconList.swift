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
                        .padding()
                    }
                }
            }
        }
        .sheet(item: $setPath) {
            ChangeView(setPath: $0)
                .onDisappear {
                    setPath = nil
                }
        }
        .searchable(text: $searchText)
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
