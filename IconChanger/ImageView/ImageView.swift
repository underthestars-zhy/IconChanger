//
//  ImageView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/28.
//  Modified by seril on 2023/6/25.
//

import SwiftUI
import LaunchPadManagerDBHelper

struct ImageView: View {
    let icon: IconRes
    let setPath: LaunchPadManagerDBHelper.AppInfo
    @State var preview: NSImage?

    var body: some View {
        ImageViewCore(nsimage: $preview, setPath: setPath)
                .task {
                    do {
                        preview = try await MyRequestController().sendRequest(icon.lowResPngUrl)
                    } catch {
                        print(error)
                    }
                }
    }
}

//struct ImageView: View {
//    let icon: IconRes
//    let setPath: LaunchPadManagerDBHelper.AppInfo
//    @State var preview: NSImage?
//
////    @Binding var showPro: Bool
//
//    @State private var isTaskRunning = false
//    @State private var task: Task<Void, Never>? = nil
//
//    // Add a new State variable for showing an alert
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    var body: some View {
//        Group {
//            if let preview = preview {
//                Image(nsImage: preview)
//                        .resizable()
//                        .scaledToFit()
//                        .onTapGesture {
//                            task = Task {
//                                do {
//                                    isTaskRunning = true
//
//                                    guard let nsimage = try await MyRequestController().sendRequest(icon.icnsUrl) else {
//                                        isTaskRunning = false
//                                        return
//                                    }
//                                    try IconManager.shared.setImage(nsimage, app: setPath)
//                                    isTaskRunning = false
//
//                                    alertMessage = "Icon changed successfully."
//                                    showAlert = true
//
//
//                                } catch {
//                                    alertMessage = "Failed to change the icon: \(error.localizedDescription)"
//                                    showAlert = true
//                                    print(error)
//                                }
//                            }
//                        }
//            } else {
//                Image("Unknown")
//                        .resizable()
//                        .scaledToFit()
//                        .overlay {
//                            ProgressView()
//                        }
//                        .task {
//                            do {
//                                preview = try await MyRequestController().sendRequest(icon.lowResPngUrl)
//                            } catch {
//                                print(error)
//                            }
//                        }
//            }
//        }
//                .sheet(isPresented: $isTaskRunning) {
//                    VStack {
//                        ProgressView() {
//                            Text("Changing the icon...")
//                                    .font(.title2)
//                                    .fontWeight(.semibold)
//                        }
//                                .padding(.bottom, 5)
//                        Button(action: {
//                            task?.cancel()
//                            isTaskRunning = false
//                        }) {
//                            Text("Cancel")
//                        }
//                    }
//                            .padding(20)
//                            .frame(minWidth: 250, minHeight: 100)
//                }
//
//                .alert(isPresented: $showAlert) {
//                    Alert(title: Text(alertMessage),
//                            dismissButton: .default(Text("OK")))
//                }
//
//    }
//
//    func saveImage(_ image: NSImage) -> Data? {
//        guard
//                let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
//        else {
//            return nil
//        } // TODO: handle error
//        let newRep = NSBitmapImageRep(cgImage: cgImage)
//        newRep.size = image.size // if you want the same size
//        guard
//                let pngData = newRep.representation(using: .png, properties: [:])
//        else {
//            return nil
//        } // TODO: handle error
//        return pngData
//    }
//}



