//
//  ChangeView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//  Modified by seril on 2023/7/25.
//

import SwiftUI
import LaunchPadManagerDBHelper

struct ChangeView: View {
    let imageSize: CGFloat = 96
    let minGridSpacing: CGFloat = 8

    @State var icons: [IconRes] = []
    @State var inIcons: [URL] = []
    @State var showProgress = false
    let setPath: LaunchPadManagerDBHelper.AppInfo

    @Environment(\.presentationMode) var presentationMode

    @StateObject var iconManager = IconManager.shared

    @State var isExpanded: Bool = false

    @State var importImage = false

    var body: some View {
        GeometryReader { geometry in
            let numberOfColumns = Int((geometry.size.width - 2 * minGridSpacing) / (imageSize + minGridSpacing))
            let columns = Array(repeating: GridItem(.fixed(imageSize), spacing: minGridSpacing), count: numberOfColumns)

            ScrollView() {
                VStack {
                    Text(setPath.name).font(.title).frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text("Local")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        Button("Choose from the Local") {
                            importImage.toggle()
                        }
                    }

                    if inIcons.isEmpty {
                        ProgressView()
                                .progressViewStyle(AppStoreProgressViewStyle())
                    } else {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(inIcons.prefix(isExpanded ? inIcons.count : numberOfColumns), id: \.self) { icon in
                                LocalImageView(url: icon, setPath: setPath)
                                        .frame(width: imageSize, height: imageSize)
                            }
                        }
                        if !isExpanded && inIcons.count > numberOfColumns {
                            Button(action: {
                                isExpanded = true
                            }) {
                                Text("Show More")
                                        .frame(maxWidth: .infinity)
                                        .padding()
                            }
                        }
                    }

                    Divider().padding(.top, 10)
                            .padding(.bottom, 10)

                    Text("macOSicons.com")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)

                    if icons.isEmpty {
                        VStack {
                            Spacer()
                            ProgressView()
                                    .progressViewStyle(AppStoreProgressViewStyle())
                            Spacer()
                        }
                    } else {
                        ZStack {
                            LazyVGrid(columns: columns, alignment: .leading) {
                                ForEach(icons, id: \.self) { icon in
                                    ImageView(icon: icon, setPath: setPath, showPro: $showProgress)
                                            .frame(width: imageSize, height: imageSize) // Make sure the image view fits in the grid
                                }
                            }
                                    .disabled(showProgress)

                            if showProgress {
                                ProgressView()
                                        .progressViewStyle(AppStoreProgressViewStyle())
                            }
                        }
                    }
                }
                        .padding()
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
                .padding(10)
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
//                .navigationTitle(setPath.name)
    }
}

struct AppStoreProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ProgressView(configuration)
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                    .scaleEffect(0.5, anchor: .center)
            Text("Loading")
                    .font(.footnote)
                    .foregroundColor(.primary)
        }
    }
}
