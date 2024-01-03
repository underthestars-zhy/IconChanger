//
//  LocalImageView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/12/18.
//  Modified by seril on 2023/7/25.
//

import SwiftUI
import LaunchPadManagerDBHelper

struct LocalImageView: View {
    let url: URL
    let setPath: LaunchPadManagerDBHelper.AppInfo

    @State var nsimage: NSImage?

    var body: some View {
        ImageViewCore(nsimage: $nsimage, setPath: setPath)
                .task {
                    do {
                        nsimage = try await MyRequestController().sendRequest(url)
                    } catch {
                        print(error)
                    }
                }
    }
}