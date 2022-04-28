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

    @State var icons = [URL]()
    @State var showChangeView = false
    @State var setPath: String = ""

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: rules) {
                ForEach(iconManager.apps, id: \.self) { app in
                    VStack {
                        Button {
                            icons = iconManager.findRelated(app)
                            setPath = app
                            showChangeView.toggle()
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
            }
        }
        .sheet(isPresented: $showChangeView) {
            ChangeView(icons: icons, setPath: setPath)
        }
    }
}
