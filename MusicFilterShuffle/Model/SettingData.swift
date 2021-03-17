//
//  SettingData.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/02.
//

import Foundation
import SwiftUI

final class SettingData: ObservableObject {
    @Published var selectMusicCount: Int = 10
    @Published var selectAlbumMinTracks: Int = 6
    @Published var autoPlay: Bool = true
    @Published var iCloud: Bool = false
    @Published var releaseYear: Double = 2000
    
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
        if let releaseYear = userdefault.object(forKey: "releaseYear") as? Double {
            self.releaseYear = releaseYear
        }
    }
    
    func save() {
        print("SettingData." + #function)
        self.userdefault.set(self.selectAlbumMinTracks, forKey: "selectAlbumMinTracks")
        self.userdefault.set(self.selectMusicCount, forKey: "selectMusicCount")
        self.userdefault.set(self.autoPlay, forKey: "autoPlay")
        self.userdefault.set(self.iCloud, forKey: "iCloud")
        self.userdefault.set(self.releaseYear, forKey: "releaseYear")
    }
    
    func colums() -> [GridItem] {
        var result: [GridItem] = []
        var items = 2
        if UIDevice.current.userInterfaceIdiom == .pad {
            items = 4
        }
        for _ in 0..<items {
            result.append(GridItem(spacing: 16))
        }            
        return result
    }
}
