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
    
    func save() {
        print("SettingData." + #function)
    }
}
