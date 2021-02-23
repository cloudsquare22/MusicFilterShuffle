//
//  Music.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import Foundation
import MediaPlayer

final class Music: ObservableObject {
    var player: MPMusicPlayerController? = nil
    
    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
    }

    func countMinFilter() {
        let mPMediaQuery = MPMediaQuery.songs()
        if let collections = mPMediaQuery.collections {
            print(collections.count)
        }
    }

}
