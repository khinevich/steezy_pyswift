//
//  ContentView.swift
//  Steezy_pyswift
//
//  Created by Mikhail Khinevich on 12.05.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FriendListView()
                .tabItem {
                    Label("Friends", systemImage: "person.crop.circle")
                }
            Text("Chat TBD)")
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
        }
    }
}

#Preview {
    ContentView()
}
