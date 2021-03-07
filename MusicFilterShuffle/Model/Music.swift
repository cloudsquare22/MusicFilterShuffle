//
//  Music.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import Foundation
import MediaPlayer
import Algorithms

final class Music: ObservableObject {
    var player: MPMusicPlayerController? = nil
    var playItems: [MPMediaItem] = []
    
    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
    }

    func countMinFilter() {
        let mPMediaQuery = MPMediaQuery.songs()
        if let collections = mPMediaQuery.collections {
            print(collections.count)
        }
    }
    
    func lastPlayedDateOld(selectMusicCount: Int) {
        let items = self.songs()
        let filteritems = items.filter{$0.lastPlayedDate != nil}
        print("---------- sort ----------")
        print(Date())
        let sortcitems = filteritems.sorted(by: { a, b in
            let adate = a.lastPlayedDate!
            let bdate = b.lastPlayedDate!
            return adate < bdate
        })
        print(Date())
        print("---------- play items ----------")
        self.playItems = Array(sortcitems.prefix(selectMusicCount))
        self.printPlayItems()
    }
    
    func lastPlayedDateNew(selectMusicCount: Int) {
        let items = self.songs()
        let filteritems = items.filter{$0.lastPlayedDate != nil}
        print("---------- sort ----------")
        print(Date())
        let sortcitems = filteritems.sorted(by: { a, b in
            let adate = a.lastPlayedDate!
            let bdate = b.lastPlayedDate!
            return adate > bdate
        })
        print(Date())
        print("---------- play items ----------")
        self.playItems = Array(sortcitems.prefix(selectMusicCount))
        self.printPlayItems()
    }

    func playCountMax(selectMusicCount: Int) {
        let items = self.songs()
        print("---------- sort ----------")
        print(Date())
        let sortcitems = items.sorted(by: { a, b in
            return a.playCount > b.playCount
        })
        print(Date())
        print("---------- play items ----------")
        self.playItems = Array(sortcitems.prefix(selectMusicCount))
        self.printPlayItems()
    }
    
    func playCountMin(selectMusicCount: Int) {
        let items = self.songs()
        print("---------- sort ----------")
        print(Date())
        let sortcitems = items.sorted(by: { a, b in
            return a.playCount < b.playCount
        })
        print(Date())
        print("---------- play items ----------")
        self.playItems = Array(sortcitems.prefix(selectMusicCount))
        self.printPlayItems()
    }
    
    func songs() -> [MPMediaItem] {
        var retsult: [MPMediaItem] = []
        let iCloudFilter = MPMediaPropertyPredicate(value: MusicFilterShuffleApp.settingData.iCloud,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let mPMediaQuery = MPMediaQuery.songs()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        if let items = mPMediaQuery.items {
            print(items.count)

            print("---------- randam ----------")
            print(Date())
            let randamcitems = items.randomSample(count: items.count)
            print(Date())
            retsult = randamcitems
        }
        return retsult
    }
    
    func play() {
        let playQueue: MPMediaItemCollection = MPMediaItemCollection(items: self.playItems)
        player?.setQueue(with: playQueue)
        player?.play()
    }
    
    func printPlayItems() {
        self.playItems.forEach({ item in
            if item.lastPlayedDate != nil {
                print("\(item.title!):\(item.albumTitle!):\(item.playCount):\(item.lastPlayedDate!)")
            }
            else {
                print("\(item.title!):\(item.albumTitle!):\(item.playCount):-")
            }
        })
    }

}
