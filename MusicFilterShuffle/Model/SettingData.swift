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
    @Published var hideSongTitle = false
    @Published var iCloud: Bool = false
    @Published var releaseYear: Double = 2000
    @Published var timeLimit: Double = 60
    @Published var filterDispOnOffMap: [String: Bool] = [:]
    @Published var selectLibrary: UInt64 = 0
    @Published var selectLibrarys: [UInt64] = []

    var timeLimitSec: Double {
        self.timeLimit * 60
    }
    
    var currentYear: Double {
        let dc = Calendar.current.dateComponents(in: .current, from: Date())
        var result: Double = 1950
        if let year = dc.year {
            result = Double(year)
        }
        return result
    }
    
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
        if let hideSongTitle = userdefault.object(forKey: "hideSongTitle") as? Bool {
            self.hideSongTitle = hideSongTitle
        }
        if let iCloud = userdefault.object(forKey: "iCloud") as? Bool {
            self.iCloud = iCloud
        }
        if let releaseYear = userdefault.object(forKey: "releaseYear") as? Double {
            self.releaseYear = releaseYear
        }
        if let timeLimit = userdefault.object(forKey: "timeLimit") as? Double {
            self.timeLimit = timeLimit
        }
        if let filterDispOnOffMap = userdefault.dictionary(forKey: "filterDispOnOffMap") {
            for filterDispOnOff in filterDispOnOffMap {
                if let value = filterDispOnOff.value as? Bool {
                    self.filterDispOnOffMap[filterDispOnOff.key] = value
                }
            }
        }
        if let selectLibrary = userdefault.object(forKey: "selectLibrary") as? UInt64 {
            self.selectLibrary = selectLibrary
//            MusicFilterShuffleApp.music.matchSelectLibrary(selectLibrary: selectLibrary)
        }
        if let selectLibrarys = userdefault.object(forKey: "selectLibrarys") as? [UInt64], selectLibrarys.count != 0 {
            self.selectLibrarys = selectLibrarys
        }
        else {
            self.selectLibrarys.append(self.selectLibrary)
        }

//        print(Music.Filter.release.rawValue)
//        print(self.filterDispOnOffMap[Music.Filter.release.rawValue])
//        self.filterDispOnOffMap[Music.Filter.release.rawValue] = false
        print("filterDispOnOffMap:\(self.filterDispOnOffMap)")
    }
    
    func save() {
        print("SettingData." + #function)
        self.userdefault.set(self.selectAlbumMinTracks, forKey: "selectAlbumMinTracks")
        self.userdefault.set(self.selectMusicCount, forKey: "selectMusicCount")
        self.userdefault.set(self.autoPlay, forKey: "autoPlay")
        self.userdefault.set(self.hideSongTitle, forKey: "hideSongTitle")
        self.userdefault.set(self.iCloud, forKey: "iCloud")
        self.userdefault.set(self.releaseYear, forKey: "releaseYear")
        self.userdefault.set(self.timeLimit, forKey: "timeLimit")
        self.userdefault.set(self.filterDispOnOffMap, forKey: "filterDispOnOffMap")
        self.userdefault.set(self.selectLibrary, forKey: "selectLibrary")
        self.userdefault.set(self.selectLibrarys, forKey: "selectLibrarys")
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
