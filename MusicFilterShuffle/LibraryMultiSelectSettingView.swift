//
//  LibraryMultiSelectSettingView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2024/08/15.
//

import SwiftUI

struct LibraryMultiSelectSettingView: View {
    @EnvironmentObject var settingData: SettingData
    @EnvironmentObject var music: Music

    var body: some View {
        Section(content: {
            NavigationLink(destination: {
                LibraryMultiSekectView()
            }, label: {
                HStack {
                    LibraryLabelView()
                    Text("\(self.settingData.selectLibrarys.count)")
                    Text("Library")
                }
            })
        },
        header: {
            HStack {
                Label("Library", systemImage: "ipod")
            }
        })
    }
}

struct LibraryMultiSekectView: View {
    @EnvironmentObject var settingData: SettingData
    @EnvironmentObject var music: Music
    
    var body: some View {
        List {
            ForEach(0..<self.music.playlistList.count, id: \.self) { index in
                HStack {
                    if index == 0 {
                        Image(systemName: "square.stack")
                    }
                    else {
                        Image(systemName: "music.note.list")
                    }
                    Text(self.music.playlistList[index].1)
                    Spacer()
                    if self.settingData.selectLibrarys.contains(0) == true, self.music.playlistList[index].0 != 0 {
                        Image(systemName: "square")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    else if self.settingData.selectLibrarys.contains(self.music.playlistList[index].0) == false {
                        Image(systemName: "square")
                            .onTapGesture {
                                print("\(index) on")
                                if self.music.playlistList[index].0 == 0 {
                                    self.settingData.selectLibrarys.removeAll()
                                }
                                if self.settingData.selectLibrarys.contains(0) == false {
                                    self.settingData.selectLibrarys.append(self.music.playlistList[index].0)
                                }
                                self.settingData.save()
                                print(self.settingData.selectLibrarys)
                            }
                            .font(.title)
                    }
                    else {
                        Image(systemName: "checkmark.square")
                            .onTapGesture {
                                print("\(index) on")
                                print("\(index) off")
                                let nowSelectLibrarys: [UInt64] = self.settingData.selectLibrarys
                                self.settingData.selectLibrarys = nowSelectLibrarys.filter({ value in
                                    value != self.music.playlistList[index].0
                                })
                                self.settingData.save()
                                print(self.settingData.selectLibrarys)
                            }
                            .font(.title)
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Library")
        .onDisappear() {
            print("LibraryMultiSekectView.\(#function)")
            if self.settingData.selectLibrarys.count == 0 {
                self.settingData.selectLibrarys.append(0)
                self.settingData.save()
            }
        }
    }
}

#Preview {
    LibraryMultiSelectSettingView()
        .environmentObject(SettingData())
        .environmentObject(Music())
}

struct LibraryLabelView: View {
    @State var onLibraryInformation = false

    var body: some View {
        Text("Library")
        if UIDevice.current.userInterfaceIdiom == .pad {
            Image(systemName: "info.bubble")
                .font(.title2)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.onLibraryInformation.toggle()
                }
                .popover(isPresented: self.$onLibraryInformation, content: {
                    LibraryInfomationView()
                })
        }
        else {
            Image(systemName: "info.bubble")
                .font(.title2)
                .foregroundColor(.blue)
                .onTapGesture {
                    self.onLibraryInformation.toggle()
                }
                .sheet(isPresented: self.$onLibraryInformation, content: {
                    LibraryInfomationView()
                    if #available(iOS 16.0, *) {
                        Spacer()
                            .presentationDetents([.height(375.0)])
                    }
                    else {
                        Spacer()
                    }
                })
        }
        Spacer()
    }
}

struct LibraryInfomationView: View {
    var body: some View {
        Label("Library", systemImage: "info.bubble")
            .font(.title)
            .padding(16.0)
        Text("You can choose from the music library and playlists.")
        VStack(alignment: .leading, spacing: 8.0) {
            Label("Music Library", systemImage: "music.note.list")
                .font(.title3)
            Text("All albums are eligible.")
                .padding(.leading, 16.0)
            Text("")
                .padding(.leading, 16.0)
            Label("Playlist", systemImage: "music.note.list")
                .font(.title3)
            Text("Albums in the playlist are eligible.")
                .padding(.leading, 16.0)
            Text("The songs in the album are only those registered in the playlist.")
                .padding(.leading, 16.0)
        }
        .padding(16.0)
    }
}
