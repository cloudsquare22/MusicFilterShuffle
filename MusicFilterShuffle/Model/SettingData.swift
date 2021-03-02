//
//  SettingData.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/02.
//

import Foundation

final class SettingData: ObservableObject {
    @Published var selectMusicCount:Int = 10
    
    let userdefault = UserDefaults.standard
    
    init() {
        self.selectMusicCount = self.userdefault.integer(forKey: "selectMusicCount")
        if self.selectMusicCount == 0 {
            self.selectMusicCount = 10
        }
    }
    
    func save() {
        print("SettingData." + #function)
        self.userdefault.set(self.selectMusicCount, forKey: "selectMusicCount")
    }
}
