//
//  APISettingsView.swift
//  IconChanger
//
//  Created by seril on 7/25/23.
//

import SwiftUI

import SwiftUI

struct APISettingsView: View {
    @AppStorage("queryHost") var queryHost: String = "p1txh7zfb3-3.algolianet.com"

    var body: some View {
        Form {
            TextField("Query Host: ", text: $queryHost, onCommit: {
                if queryHost.isEmpty {
                    queryHost = "p1txh7zfb3-3.algolianet.com"
                }
            })
            Spacer()
        }
    }
}

