//
//  IconList.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

struct IconList: View {
    @StateObject var iconManager = IconManager.shared

    let rules = [GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top)]

    @State var setPath: String? = nil

    @State var searchText: String = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: rules) {
                if !searchText.isEmpty {
                    ForEach(iconManager.findSearchedImage(searchText), id: \.self) { app in
                        VStack {
                            Button {
                                setPath = app
                            } label: {
                                Image(nsImage: NSWorkspace.shared.icon(forFile: app))
                                    .resizable()
                                    .scaledToFit()
                                    .padding(.bottom)
                            }
                            .buttonStyle(BorderlessButtonStyle())

                            Text(iconManager.getAppName(app))
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    }
                } else {
                    ForEach(iconManager.apps, id: \.self) { app in
                        if let rep = NSWorkspace.shared.icon(forFile: app)
                            .bestRepresentation(for: NSRect(x: 0, y: 0, width: 1024, height: 1024), context: nil, hints: nil) {
                            VStack {
                                Button {
                                    setPath = app
                                } label: {
                                    Image(nsImage: { () -> NSImage in
                                        let image = NSImage(size: rep.size)
                                        image.addRepresentation(rep)
                                        return image
                                    }())
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.bottom)
                                }
                                .buttonStyle(BorderlessButtonStyle())

                                Text(iconManager.getAppName(app))
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
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
