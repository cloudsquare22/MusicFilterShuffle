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

    enum Filter {
        case oldday
        case nowaday
        case forgotten
        case heavyrotation
        case albumshuffle
        case albumnotcomplete
        case release
        case shuffle
        case playtime
    }
    
    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
    }

    func runFilter(filter: Filter) {
        let selectMusicCount = MusicFilterShuffleApp.settingData.selectMusicCount
        switch filter {
        case .oldday:
            self.lastPlayedDateOld(selectMusicCount: selectMusicCount)
        case .nowaday:
            self.lastPlayedDateNew(selectMusicCount: selectMusicCount)
        case .forgotten:
            self.playCountMin(selectMusicCount: selectMusicCount)
        case .heavyrotation:
            self.playCountMax(selectMusicCount: selectMusicCount)
        case .albumshuffle:
            self.playAlbumShuffle()
        case .albumnotcomplete:
            self.playAlbumComplete()
        case .release:
            self.songsReleaseYear(selectMusicCount: selectMusicCount)
        case .shuffle:
            self.songsShuffle(selectMusicCount: selectMusicCount)
        case .playtime:
            self.songsShufflePlayTime()
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
    
    func playAlbumShuffle() {
        let collections = self.albums()
        print("---------- select ----------")
        print(Date())
        var items: [MPMediaItem] = []
        for collection in collections {
            if collection.items.count >= MusicFilterShuffleApp.settingData.selectAlbumMinTracks {
                items = collection.items
                break
            }
        }
        print(Date())
        print("---------- play items ----------")
        self.playItems = items
        self.printPlayItems()
    }

    func playAlbumComplete() {
        let collections = self.albums()
        print("---------- select ----------")
        print(Date())
        var items: [MPMediaItem] = []
        for collection in collections {
//            if collection.items.count < MusicFilterShuffleApp.settingData.selectAlbumMinTracks {
//                continue
//            }
            items = self.albumNotPlay(items: collection.items)
            if items.isEmpty == false {
                items.sort(by: { (item1, item2) in
                    item1.discNumber < item2.discNumber && item1.albumTrackNumber < item2.albumTrackNumber
                })
//                for item in items {
//                    print("** \(item.title!):\(item.discNumber):\(item.albumTrackNumber)")
//                }
                break
            }
        }
        print(Date())
        print("---------- play items ----------")
        self.playItems = items
        self.printPlayItems()
    }
    
    func albumNotPlay(items: [MPMediaItem]) -> [MPMediaItem] {
        var result : [MPMediaItem] = []
        for item in items {
            if item.playCount == 0 {
                result.append(item)
            }
        }
        return result
    }

    func songsReleaseYear(selectMusicCount: Int) {
        let releaseYear = Int(MusicFilterShuffleApp.settingData.releaseYear)
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(from: DateComponents(year: releaseYear, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: releaseYear, month: 12, day: 31))!
        let items = self.songs()
        let filteritems = items.filter{$0.releaseDate != nil && startDate <= $0.releaseDate! && $0.releaseDate! <= endDate}
        print("---------- play items ----------")
        self.playItems = Array(filteritems.prefix(selectMusicCount))
        self.printPlayItems()
    }
    
    func songsShuffle(selectMusicCount: Int) {
        let items = self.songs()
        print("---------- play items ----------")
        self.playItems = Array(items.prefix(selectMusicCount))
        self.printPlayItems()
    }

    func songsShufflePlayTime() {
        let items = self.songs()
        print("---------- play items ----------")
        var totalTime = 0.0
        var playItems: [MPMediaItem] = []
        for item in items {
            totalTime = totalTime + item.playbackDuration
            if totalTime > 3600 {
                print("Total Time:\(totalTime - item.playbackDuration)")
                break
            }
            playItems.append(item)
        }
        self.playItems = playItems
        self.printPlayItems()
    }

    func songs() -> [MPMediaItem] {
        var result: [MPMediaItem] = []
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
            result = randamcitems
        }
        return result
    }
    
    func albums() ->  [MPMediaItemCollection] {
        var result: [MPMediaItemCollection] = []
        let iCloudFilter = MPMediaPropertyPredicate(value: MusicFilterShuffleApp.settingData.iCloud,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let mPMediaQuery = MPMediaQuery.albums()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        if let collections = mPMediaQuery.collections {
            print(collections.count)

            print("---------- randam ----------")
            print(Date())
            let randamcollections = collections.randomSample(count: collections.count)
            print(Date())
            result = randamcollections
        }
        return result
    }
    
    func play() {
        if self.playItems.isEmpty == false {
            let playQueue: MPMediaItemCollection = MPMediaItemCollection(items: self.playItems)
            player?.setQueue(with: playQueue)
            player?.play()
        }
    }
    
    func printPlayItems() {
        self.playItems.forEach({ item in
            if item.releaseDate != nil {
                print("\(item.title!):\(item.albumTitle!):\(item.playCount):\(item.releaseDate!)")
            }
            else {
                print("\(item.title!):\(item.albumTitle!):\(item.playCount):-")
            }
        })
    }

}
