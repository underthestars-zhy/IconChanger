//
//  ChangeView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

struct ChangeView: View {
    let rules = [GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top),
                 GridItem(.flexible(), alignment: .top)]

    let icons: [URL]
    let setPath: String

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: rules) {
                ForEach(icons, id: \.self) { icon in
                    ImageView(url: icon, setPath: setPath)
                }

                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .frame(width: 500, height: 400)
    }
}
