//
//  MusicFilterShuffleApp.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import SwiftUI

@main
struct MusicFilterShuffleApp: App {
    static var music: Music = Music()
    static var settingData: SettingData = SettingData()

    var body: some Scene {
        WindowGroup {
            FiltersView()
                .environmentObject(MusicFilterShuffleApp.music)
                .environmentObject(MusicFilterShuffleApp.settingData)
        }
    }
}
