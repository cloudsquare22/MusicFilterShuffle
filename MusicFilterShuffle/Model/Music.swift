//
//  Music.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import Foundation
import MediaPlayer
import Algorithms
import SwiftUI

final class Music: ObservableObject {
    var player: MPMusicPlayerController? = nil
    var playItems: [MPMediaItem] = []
    var totalTime: Double = 0.0
    
    @Published var playlistList: [(UInt64, String)] = []
    
    enum Filter: String {
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
    
    let iCloudFilter = MPMediaPropertyPredicate(value: true,
                                                forProperty: MPMediaItemPropertyIsCloudItem,
                                                comparisonType: .equalTo)

    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
        self.setPlaylistList()
    }
    
    func runFilter(filter: Filter) {
        switch filter {
        case .oldday:
            self.lastPlayedDateOld()
        case .nowaday:
            self.lastPlayedDateNew()
        case .forgotten:
            self.playCountMin()
        case .heavyrotation:
            self.playCountMax()
        case .albumshuffle:
            self.playAlbumShuffle()
        case .albumnotcomplete:
            self.playAlbumComplete()
        case .release:
            self.songsReleaseYear()
        case .shuffle:
            self.songsShuffle()
        case .playtime:
            self.songsShufflePlayTime()
        }
    }
    
    func lastPlayedDateOld() {
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
        self.playItems = Array(sortcitems.prefix(MusicFilterShuffleApp.settingData.selectMusicCount))
        self.printPlayItems()
    }
    
    func lastPlayedDateNew() {
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
        self.playItems = Array(sortcitems.prefix(MusicFilterShuffleApp.settingData.selectMusicCount))
        self.printPlayItems()
    }
    
    func playCountMax() {
        let items = self.songs()
        print("---------- sort ----------")
        print(Date())
        let sortcitems = items.sorted(by: { a, b in
            return a.playCount > b.playCount
        })
        print(Date())
        print("---------- play items ----------")
        self.playItems = Array(sortcitems.prefix(MusicFilterShuffleApp.settingData.selectMusicCount))
        self.printPlayItems()
    }
    
    func playCountMin() {
        let items = self.songs()
        print("---------- sort ----------")
        print(Date())
        let sortcitems = items.sorted(by: { a, b in
            return a.playCount < b.playCount
        })
        print(Date())
        var maps: [Int : Int] = [:]
        sortcitems.forEach({ item in
            if let count = maps[item.playCount] {
                maps[item.playCount] = count + 1
            }
            else {
                maps[item.playCount] = 1
            }
        })
        print(maps)
        print("---------- play items ----------")
        self.playItems = Array(sortcitems.prefix(MusicFilterShuffleApp.settingData.selectMusicCount))
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
    
    func songsReleaseYear() {
        let releaseYear = Int(MusicFilterShuffleApp.settingData.releaseYear)
        let calendar = Calendar(identifier: .gregorian)
        let startDate = calendar.date(from: DateComponents(year: releaseYear, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: releaseYear, month: 12, day: 31))!
        let items = self.songs()
        let filteritems = items.filter{$0.releaseDate != nil && startDate <= $0.releaseDate! && $0.releaseDate! <= endDate}
        print("---------- play items ----------")
        self.playItems = Array(filteritems.prefix(MusicFilterShuffleApp.settingData.selectMusicCount))
        self.printPlayItems()
    }
    
    func songsShuffle() {
        let items = self.songs()
        print("---------- play items ----------")
        self.playItems = Array(items.prefix(MusicFilterShuffleApp.settingData.selectMusicCount))
        self.printPlayItems()
    }
    
    func songsShufflePlayTime() {
        let items = self.songs()
        print("---------- play items ----------")
        self.totalTime = 0.0
        var playItems: [MPMediaItem] = []
        var lastSelectCount = 0
        for item in items {
            if self.totalTime + item.playbackDuration > MusicFilterShuffleApp.settingData.timeLimitSec {
                if lastSelectCount > 100 {
                    print("Total Time:\(self.totalTime)")
                    break
                }
                else {
                    lastSelectCount = lastSelectCount + 1
                }
            }
            else {
                if lastSelectCount > 0 {
                    print("last 1 mile:\(item.title!)")
                }
                self.totalTime = self.totalTime + item.playbackDuration
                playItems.append(item)
            }
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

        var items: [MPMediaItem] = []

        if MusicFilterShuffleApp.settingData.selectLibrary == 0 {
            if let mPMediaQueryItems = mPMediaQuery.items {
                items = mPMediaQueryItems
            }
        }
        else {
            items = self.playList(playlistid: MusicFilterShuffleApp.settingData.selectLibrary)
        }
        print(items.count)
        
        print("---------- randam ----------")
        print(Date())
        let randamcitems = items.randomSample(count: items.count)
        print(Date())
        result = randamcitems
        
        return result
    }
    
    func albums() ->  [MPMediaItemCollection] {
        var result: [MPMediaItemCollection] = []
        let iCloudFilter = MPMediaPropertyPredicate(value: MusicFilterShuffleApp.settingData.iCloud,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let mPMediaQuery = MPMediaQuery.albums()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        
        var collections: [MPMediaItemCollection] = []
        if MusicFilterShuffleApp.settingData.selectLibrary == 0 {
            if let mPMediaQueryCollections = mPMediaQuery.collections {
                collections = mPMediaQueryCollections
            }
        }
        else {
            collections = self.playList(playlistid: MusicFilterShuffleApp.settingData.selectLibrary)
        }
        print(collections.count)
        
        print("---------- randam ----------")
        print(Date())
        let randamcollections = collections.randomSample(count: collections.count)
        print(Date())
        result = randamcollections

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
    
    func totalTimeToString() -> String {
        var result = ""
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .short
        formatter.allowedUnits = [.minute, .second]
        result = formatter.string(from: self.totalTime)!
        return result
    }
    
    func countPlayCount() -> [(String, String)] {
        print(#function)
        
        let items = self.songs()
        var maps: [Int : Int] = [:]
        items.forEach({ item in
            let count = maps[item.playCount] == nil ? 0 : maps[item.playCount]
            maps[item.playCount] = count! + 1
        })
        print(maps)
        var mapsString: [(String, String)] = []
        for key in maps.keys.sorted() {
            let textleft = NSLocalizedString("Play ", comment: "") + String(key) + NSLocalizedString(" times", comment: "")
            let textright = String(maps[key]!) + NSLocalizedString(" songs", comment: "")
            mapsString.append((textleft, textright))
        }
        
        return mapsString
    }
    
    func countReleaseYear() -> [(String, String)] {
        print(#function)
        
        let items = self.songs()
        var maps: [Int : Int] = [:]
        items.forEach({ item in
            if let release = item.releaseDate {
                let datecomponents = Calendar.current.dateComponents(in: .current, from: release)
                if let year = datecomponents.year {
                    let count = maps[year] == nil ? 0 : maps[year]
                    maps[year] = count! + 1
                }
                else {
                    let count = maps[0] == nil ? 0 : maps[0]
                    maps[0] = count! + 1
                }
            }
        })
        print(maps)
        print(Locale.current.identifier)
        var mapsString: [(String, String)] = []
        for key in maps.keys.sorted() {
            var textleft = ""
            if Locale.current.identifier == "en_US" {
                textleft = String(key) + "."
            }
            else {
                textleft = String(key) + NSLocalizedString(" year", comment: "")
            }
            let textright = String(maps[key]!) + NSLocalizedString(" songs", comment: "")
            mapsString.append((textleft, textright))
        }
        
        return mapsString
    }
    
    func artwork(item: MPMediaItem) -> Image {
        var result: Image = Image(systemName: "opticaldisc")
        if let value = item.artwork {
            if let image = value.image(at: CGSize(width: value.bounds.width, height: value.bounds.height)) {
                result = Image(uiImage: image)
            }
        }
        return result
    }
    
    func playList(playlistid: UInt64) -> [MPMediaItem] {
        print("\(playlistid)")
        var result: [MPMediaItem] = []
        let iCloudFilter = MPMediaPropertyPredicate(value: true,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let idFilter = MPMediaPropertyPredicate(value: playlistid,
                                                forProperty: MPMediaPlaylistPropertyPersistentID,
                                                comparisonType: .equalTo)
        let mPMediaQuery = MPMediaQuery.playlists()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        mPMediaQuery.addFilterPredicate(idFilter)
        if let collections = mPMediaQuery.collections, collections.count > 0 {
            for item in collections[0].items {
                if MusicFilterShuffleApp.settingData.iCloud == false, item.isCloudItem == true {
                    continue
                }
//                print(String(item.albumPersistentID) + ":" + item.albumTitle! + ":" + item.title!)
                result.append(item)
            }
            print(result.count)
        }
        return result
    }
    
    func playList(playlistid: UInt64) -> [MPMediaItemCollection] {
        var result: [MPMediaItemCollection] = []
        let mPMediaQuery = MPMediaQuery.playlists()
        let idFilter = MPMediaPropertyPredicate(value: playlistid,
                                                forProperty: MPMediaPlaylistPropertyPersistentID,
                                                comparisonType: .equalTo)
        mPMediaQuery.addFilterPredicate(self.iCloudFilter)
        mPMediaQuery.addFilterPredicate(idFilter)
        if let collections = mPMediaQuery.collections, collections.count > 0 {
            var maps: [UInt64:MPMediaItemCollection] = [:]
            for item in collections[0].items {
                if MusicFilterShuffleApp.settingData.iCloud == false, item.isCloudItem == true {
                    continue
                }
                print(String(item.albumPersistentID) + ":" + item.albumTitle! + ":" + item.title!)
                if let itemCollection = maps[item.albumPersistentID] {
                    var items = itemCollection.items
                    items.append(item)
                    let itemCollection = MPMediaItemCollection(items: items)
                    maps[item.albumPersistentID] = itemCollection
                }
                else {
                    let itemCollection = MPMediaItemCollection(items: [item])
                    maps[item.albumPersistentID] = itemCollection
                }
            }
            print(maps.count)
            for map in maps {
                result.append(map.value)
            }
        }
        return result
    }

    func setPlaylistList() {
        print(#function)
        self.playlistList = []
        let mPMediaQuery = MPMediaQuery.playlists()
        mPMediaQuery.addFilterPredicate(self.iCloudFilter)
        if let collections = mPMediaQuery.collections {
            for collection in collections {
                if (collection.mediaTypes == .music) && (collection.items.count > 0) {
                    if let id = collection.value(forProperty: MPMediaPlaylistPropertyPersistentID) as? UInt64,
                        let name = collection.value(forProperty: MPMediaPlaylistPropertyName) as? String {
                        self.playlistList.append((id, name))
                    }
                }
            }
        }
        self.playlistList.sort(by: {
            p1, p2 in
            p1.1 < p2.1
        })
        self.playlistList.insert((0, NSLocalizedString("Music Library", comment: "")), at: 0)
        print("playlist:\(self.playlistList)")
    }

    func setPlaylistListAlbum() {
        print(#function)
        self.playlistList = []
        let iCloudFilter = MPMediaPropertyPredicate(value: true,
                                                    forProperty: MPMediaItemPropertyIsCloudItem,
                                                    comparisonType: .equalTo)
        let mPMediaQuery = MPMediaQuery.playlists()
        mPMediaQuery.addFilterPredicate(iCloudFilter)
        if let collections = mPMediaQuery.collections {
            for collection in collections {
                if (collection.mediaTypes == .music) && (collection.items.count > 0) {
                    if let id = collection.value(forProperty: MPMediaPlaylistPropertyPersistentID) as? UInt64,
                        let name = collection.value(forProperty: MPMediaPlaylistPropertyName) as? String {
                        self.playlistList.append((id, name))
                    }
                }
            }
        }
        self.playlistList.sort(by: {
            p1, p2 in
            p1.1 < p2.1
        })
        self.playlistList.insert((0, NSLocalizedString("Music Library", comment: "")), at: 0)
        print("playlist:\(self.playlistList)")
    }

    func matchSelectLibrary(selectLibrary: UInt64) -> UInt64 {
        var result: UInt64  = 0
        self.setPlaylistList()
        for playlist in self.playlistList {
            if playlist.0 == selectLibrary {
                result = selectLibrary
                break
            }
        }
        return result
    }
}
