//
//  LocalImageCore.swift
//  IconChanger
//
//  Created by seril on 7/25/23.
//

import SwiftUI
import LaunchPadManagerDBHelper
import QuartzCore

struct ImageViewCore: View {
    @Binding var nsimage: NSImage?
    let setPath: LaunchPadManagerDBHelper.AppInfo
    @State private var isTaskRunning = false
    @State private var task: Task<Void, Never>? = nil

    // Add a new State variable for showing an alert
    @State var showSnackbar = false
    @State var isSuccessful = true
    @State var failureMessage = "Failed to load data."

    var body: some View {
        Group {
                if let nsimage = nsimage {
                    Image(nsImage: nsimage)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                changeIcon(image: nsimage)
                            }
                } else {
                    Image("Unknown")
                            .resizable()
                            .scaledToFit()
                            .overlay {
                                ProgressView()
                            }
                }

            }        .overlay(
                        Group {
                            if showSnackbar {
                                SnackbarView(isPresented: $showSnackbar, isSuccessful: isSuccessful, failureMessage: failureMessage)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                                .ignoresSafeArea()
                )
                    .sheet(isPresented: $isTaskRunning) {
                        VStack {
                            ProgressView() {
                                Text("Changing the icon...")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                            }
                                    .padding(.bottom, 5)
                            Button(action: {
                                task?.cancel()
                                isTaskRunning = false
                            }) {
                                Text("Cancel")
                            }
                        }
                                .padding(20)
                                .frame(minWidth: 250, minHeight: 100)
                    }
    }
        func changeIcon(image: NSImage) {
            task = Task {
                do {
                    isTaskRunning = true
                    try IconManager.shared.setImage(image, app: setPath)
                    isTaskRunning = false
                    failureMessage = "Icon changed successfully."
                    isSuccessful = true
                    showSnackbar = true
                } catch {
                    failureMessage = "Failed to change the icon: \(error.localizedDescription)"
                    isSuccessful = false
                    showSnackbar = true
                    print(error)
                }
            }
        }

}


struct SnackbarView: View {
    @Binding var isPresented: Bool
    var isSuccessful: Bool
    var failureMessage: String

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        Group {
            if isPresented {
                if isSuccessful {
                    GeometryReader { geometry in
                        ZStack {
                            Image(systemName: "checkmark")
                                    .resizable()
                                    .frame(width: 48, height: 48)
                                    .padding()
                                    .background(VisualEffectBlur(material: .underWindowBackground, blendingMode: .withinWindow))
                                    .cornerRadius(10)
                                    .foregroundColor(Color(red: 0.24, green: 0.70, blue: 0.44)) // Light green
                                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                                .onAppear(perform: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        withAnimation {
                                            isPresented = false
                                        }
                                    }
                                })
                    }
                } else {
                    EmptyView()
                            .onAppear(perform: {
                                showAlert = true
                                alertMessage = failureMessage
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        isPresented = false
                                    }
                                }
                            })
                }
            } else {
                EmptyView()
            }
        }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
    }
}

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
