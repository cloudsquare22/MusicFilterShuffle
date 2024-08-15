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
                                print(self.settingData.selectLibrarys)
                            }
                            .font(.title)
                    }
                }
                .foregroundColor(.primary)
            }
        }
        .navigationTitle("Library")
    }
}

#Preview {
    LibraryMultiSelectSettingView()
        .environmentObject(SettingData())
        .environmentObject(Music())
}
