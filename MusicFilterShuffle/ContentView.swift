//
//  ContentView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData

    @State private var selection = 1

    var body: some View {
        TabView(selection: self.$selection) {
            SettingView()
                .tabItem {
                    VStack {
                        Image(systemName: "gearshape")
                        Text("Setting")
                    }
                }
                .tag(0)
            FiltersView()
                .tabItem {
                    VStack {
                        Image(systemName: "music.quarternote.3")
                        Text("Filters")
                    }
                }
                .tag(1)
            AboutView()
                .tabItem {
                    VStack {
                        Image(systemName: "doc")
                        Text("About")
                    }
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Music())
    }
}
