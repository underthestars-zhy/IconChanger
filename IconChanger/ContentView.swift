//
//  ContentView.swift
//  IconChanger
//
//  Created by 朱浩宇 on 2022/4/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fullDiskPermision = FullDiskPermision.shared
    @StateObject var iconManager = IconManager.shared

    
    var body: some View {
        if fullDiskPermision.hasPermision {
            Group {
                if iconManager.load {
                    ProgressView()
                        .searchable(text: .constant(""))
                } else {
                    IconList()
                }
            }
        } else {
            VStack {
                Text("We Need Full Disk Access")
                    .font(.largeTitle.bold())
                    .padding()

                VStack(alignment: .leading) {
                    Text("1. Open Setting App")
                    Text("2. Go to security")
                    Text("3. Choose Full Disk Access")
                    Text("4. Unlock")
                    Text("5. Choose or add IconChanger")
                    Text("6. Check th check box")
                }
                .multilineTextAlignment(.leading)

                Button("Check Access") {
                    fullDiskPermision.check()
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
