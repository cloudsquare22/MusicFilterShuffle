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
    var items: [MPMediaItem] = []
    
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
    
    func playCountMin(selectMusicCount: Int) {
        let mPMediaQuery = MPMediaQuery.songs()
        if let items = mPMediaQuery.items {
            print(items.count)
            
            print("---------- randam ----------")
            print(Date())
            let randamcitems = items.randomSample(count: items.count)
            print(Date())
            for index in 0..<selectMusicCount  {
                print("\(randamcitems[index].title!):\(randamcitems[index].albumTitle!):\(randamcitems[index].playCount)")
            }

            print("---------- sort ----------")
            print(Date())
            let sortcitems = randamcitems.sorted(by: { a, b in
                return a.playCount < b.playCount
            })
            print(Date())
            var playItems: [MPMediaItem] = []
            for index in 0..<selectMusicCount  {
                print("\(sortcitems[index].title!):\(sortcitems[index].albumTitle!):\(sortcitems[index].playCount)")
                playItems.append(sortcitems[index])
            }
            self.items = playItems
        }
    }
    
    func play() {
        let playQueue: MPMediaItemCollection = MPMediaItemCollection(items: self.items)
        player?.setQueue(with: playQueue)
        player?.play()
    }

}
