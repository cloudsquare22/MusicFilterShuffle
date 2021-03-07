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
    
    func lastPlayedDateOld() {
        let mPMediaQuery = MPMediaQuery.songs()
        if let collections = mPMediaQuery.collections {
            print(collections.count)

            print(Date())
            print("---------- randam ----------")
            let randamcollections = collections.randomSample(count: collections.count)
            print(Date())
            for index in 0..<10  {
                print("\(randamcollections[index].items[0].title!):\(randamcollections[index].items[0].albumTitle!)")
            }

            print(Date())
            print("---------- sort ----------")
            let sortcollections = randamcollections.sorted(by: { a, b in
                var result = true
                let adate = a.items[0].lastPlayedDate
                let bdate = b.items[0].lastPlayedDate
                if adate != nil && bdate != nil {
                    result = adate! < bdate!
                }
                else if adate != nil && bdate == nil{
                    result = false
                }
                return result
            })
            print(Date())
            for index in 0..<10  {
                print("\(sortcollections[index].items[0].title!):\(sortcollections[index].items[0].albumTitle!)")
            }
        }
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
            print("\(item.title!):\(item.albumTitle!):\(item.playCount)")
        })
    }

}
