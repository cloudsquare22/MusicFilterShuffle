//
//  FiltersView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/28.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData

    @State var onTap = false

//    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var columns: [GridItem] = [GridItem(spacing: 16), GridItem(spacing: 16)]
    
    let filtersData: [(String, String, Int)] =
        [("music.note", "A long time ago in a...", 0),
         ("music.note", "Nowadays", 1),
         ("music.note", "Forgotten", 2),
         ("music.note", "Heavy Rotation", 3),
         ("opticaldisc", "Album Shuffle", 4),
         ("music.note.list", "Album Not Complete", 5),
         ("music.note", "1989", 6)]

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<filtersData.count) { index in
                            FilterView(onTap: self.$onTap, imageName: self.filtersData[index].0, title: self.filtersData[index].1, filter: self.filtersData[index].2, size: geometry.size.width)
                        }
                    }
                    .padding(16)
                }
            }
            .navigationBarTitle("Filters", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
            .environmentObject(Music())
            .environmentObject(SettingData())
    }
}

struct FilterView: View {
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData
    @State var dispProgress: Bool = false
    @State var disapItemsView: Bool = false

    @Binding var onTap: Bool
    let imageName: String
    let title: String
    let filter: Int
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
            Text(self.title)
                .fontWeight(.light)
        }
        .font(.title2)
        .padding(16)
        .frame(width: CGFloat(abs(size / 2 - 24)), height: CGFloat(abs(size / 2 - 24)), alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 32).stroke())
        .overlay(RoundedRectangle(cornerRadius: 32).foregroundColor(Color.gray.opacity(0.0000001)))
        .overlay(OverlayProgressView(dispProgress: self.$dispProgress))
        .onTapGesture {
            if self.onTap == false {
                self.onTap = true
                self.dispProgress.toggle()
                DispatchQueue.global().async {
                    if self.filter == 0 {
                        self.music.lastPlayedDateOld(selectMusicCount: self.settingData.selectMusicCount)
                    }
                    if self.filter == 1 {
                        self.music.lastPlayedDateNew(selectMusicCount: self.settingData.selectMusicCount)
                    }
                    else if self.filter == 2 {
                        self.music.playCountMin(selectMusicCount: self.settingData.selectMusicCount)
                    }
                    else if self.filter == 3 {
                        self.music.playCountMax(selectMusicCount: self.settingData.selectMusicCount)
                    }
                    else if self.filter == 4 {
                        self.music.playAlbumShuffle()
                    }
                    else if self.filter == 5 {
                        self.music.playAlbumComplete()
                    }
                    else if self.filter == 6 {
                        self.music.songsReleaseYear(selectMusicCount: self.settingData.selectMusicCount)
                    }
                    if self.settingData.autoPlay == true {
                        self.music.play()
                    }
                    self.dispProgress.toggle()
                    self.onTap = false
                    self.disapItemsView.toggle()
                }
            }
            else {
                print("onTap Noaction!!")
            }
        }
        .onLongPressGesture {
            print("cc long")
            print("\(self.size)")
            print("\(abs(self.size / 2 - 16))")
        }
        .fullScreenCover(isPresented: self.$disapItemsView, onDismiss: {}, content: {
            if self.filter >= 4 && self.filter != 6 {
                ItemsView(isAlbum: true, dispPlay: !self.settingData.autoPlay)
            }
            else {
                ItemsView(isAlbum: false, dispPlay: !self.settingData.autoPlay)
            }
        })
    }
}

struct OverlayProgressView: View {
    @Binding var dispProgress: Bool

    var body: some View {
        if self.dispProgress == true {
            HStack {
                Spacer()
                ProgressView("selecting music...")
                Spacer()
            }
        }
    }

}
