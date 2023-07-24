//
//  SetAliasNameView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/6/27.
//

import SwiftUI

struct SetAliasNameView: View {
    let raw: String
    let lastText: String
    @State var text = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            TextField(raw, text: $text)
                    .frame(width: 350)
                    .padding()
        }
                .onAppear {
                    if !lastText.isEmpty && lastText != raw {
                        text = lastText
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Finish") {
                            if text.isEmpty {
                                AliasName.setEmpty(for: raw)
                            } else {
                                AliasName.setName(text, for: raw)
                            }

                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
    }
}
