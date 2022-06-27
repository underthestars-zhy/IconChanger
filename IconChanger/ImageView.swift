//
//  ImageView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/28.
//

import SwiftUI
import LaunchPadManagerDBHelper

struct ImageView: View {
    let url: URL
    let setPath: LaunchPadManagerDBHelper.AppInfo

    @State var nsimage: NSImage?

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        if let nsimage = nsimage {
            Image(nsImage: nsimage)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    let appPath = URL(fileURLWithPath: setPath.url.universalPath())
                    NSAppleScript(source: "do shell script \"sudo chmod 777 '\(appPath.path)'\" with administrator " + "privileges")!.executeAndReturnError(nil)

                    NSWorkspace.shared.setIcon(nsimage, forFile: appPath.universalPath())
                    presentationMode.wrappedValue.dismiss()
                }
        } else {
            Image("Unknown")
                .resizable()
                .scaledToFit()
                .overlay {
                    ProgressView()
                }
                .task {
                    do {
                        nsimage = try await MyRequestController().sendRequest(url)
                    } catch {
                        print(error)
                    }
                }
        }
    }

    func saveImage(_ image: NSImage) -> Data? {
        guard
            let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
            else { return nil } // TODO: handle error
        let newRep = NSBitmapImageRep(cgImage: cgImage)
        newRep.size = image.size // if you want the same size
        guard
            let pngData = newRep.representation(using: .png, properties: [:])
            else { return nil } // TODO: handle error
        return pngData
    }
}
