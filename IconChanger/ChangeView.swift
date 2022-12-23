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

    @State var icons: [IconRes] = []
    @State var inIcons: [URL] = []
    @State var showProgress = false
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
                    ZStack {
                        LazyVGrid(columns: rules) {
                            ForEach(icons, id: \.self) { icon in
                                ImageView(icon: icon, setPath: setPath, showPro: $showProgress)
                            }

                            Spacer()
                        }
                        .disabled(showProgress)

                        if showProgress {
                            //TODO: Make this better
                            ProgressView()
                        }
                    }
                }
            }
            .tabItem {
                Text("macOSIcon")
            }

            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: rules) {
                    ForEach(inIcons, id: \.self) { icon in
                        LocalImageView(url: icon, setPath: setPath)
                    }

                    Spacer()
                }
            }
            .tabItem {
                Text("Local")
            }
        }
        .fileImporter(isPresented: $importImage, allowedContentTypes: [.image, .icns]) { result in
            switch result {
            case .success(let url):
                if url.startAccessingSecurityScopedResource() {
                    if let nsimage = NSImage(contentsOf: url) {
                        do {
                            try IconManager.shared.setImage(nsimage, app: setPath)
                        } catch {
                            fatalError(error.localizedDescription)
                        }
                    }
                    url.stopAccessingSecurityScopedResource()
                }
            case .failure(let error):
                print(error)
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
                Button("Choose from the Local") {
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
            } catch {
                print(error)
            }
        }
    }
}
