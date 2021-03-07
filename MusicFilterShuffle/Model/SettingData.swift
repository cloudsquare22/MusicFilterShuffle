//
//  SettingData.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/02.
//

import Foundation

final class SettingData: ObservableObject {
    @Published var selectMusicCount: Int = 10
    @Published var selectAlbumMinTracks: Int = 6
    @Published var autoPlay: Bool = true
    @Published var iCloud: Bool = false
    
    let userdefault = UserDefaults.standard
    
    init() {
        self.selectMusicCount = self.userdefault.integer(forKey: "selectMusicCount")
        if self.selectMusicCount == 0 {
            self.selectMusicCount = 10
        }
        if let selectAlbumMinTracks = userdefault.object(forKey: "selectAlbumMinTracks") as? Int {
            self.selectAlbumMinTracks = selectAlbumMinTracks
        }
        if let autoPlay = userdefault.object(forKey: "autoPlay") as? Bool {
            self.autoPlay = autoPlay
        }
        if let iCloud = userdefault.object(forKey: "iCloud") as? Bool {
            self.iCloud = iCloud
        }
    }
    
    func save() {
        print("SettingData." + #function)
        self.userdefault.set(self.selectAlbumMinTracks, forKey: "selectAlbumMinTracks")
        self.userdefault.set(self.selectMusicCount, forKey: "selectMusicCount")
        self.userdefault.set(self.autoPlay, forKey: "autoPlay")
        self.userdefault.set(self.iCloud, forKey: "iCloud")
    }
}
