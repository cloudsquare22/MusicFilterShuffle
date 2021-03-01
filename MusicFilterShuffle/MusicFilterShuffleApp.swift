//
//  MusicFilterShuffleApp.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import SwiftUI

@main
struct MusicFilterShuffleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Music())
                .environmentObject(SettingData())
        }
    }
}
