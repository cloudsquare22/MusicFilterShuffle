//
//  SettingView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/28.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var settingData: SettingData
    @EnvironmentObject var music: Music

    var body: some View {
        NavigationView {
            Form {
                NavigationLink("Manual", destination: ManualView())
                LibrarySettingView()
                AllSettingView()
                SongsSettingView()
                ReleaseYearSettingView()
                TimeLimitSettingFormView()
                AlbumSettingView()
                CountView()
                AboutView()
            }
            .navigationTitle("Setting")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            print("Setting onAppear")
            self.music.setPlaylistList()
        }
        .onDisappear() {
            print("Setting onDisappear")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(SettingData())
    }
}

struct LibrarySettingView: View {
    @EnvironmentObject var settingData: SettingData
    @EnvironmentObject var music: Music
    
    var body: some View {
        Section(content: {
            if #available(iOS 16.0, *) {
                Picker(selection: self.$settingData.selectLibrary, content: {
                    ForEach(0..<self.music.playlistList.count, id: \.self) { index in
                        HStack {
                            if index == 0 {
                                Image(systemName: "square.stack")
                            }
                            else {
                                Image(systemName: "music.note.list")
                            }
                            Text(self.music.playlistList[index].1)
                        }
                        .tag(self.music.playlistList[index].0)
                        .foregroundColor(.primary)
                    }
                }, label: {
                    LibraryLabelView()
                })
                .onChange(of: self.settingData.selectLibrary, perform: { newvalue in
                    self.changeSelectLibrary()
                })
                .pickerStyle(.navigationLink)
                .labelsHidden()
            }
            else {
                Picker(selection: self.$settingData.selectLibrary, content: {
                    ForEach(0..<self.music.playlistList.count, id: \.self) { index in
                        Text(self.music.playlistList[index].1)
                            .tag(self.music.playlistList[index].0)
                            .foregroundColor(.primary)
                    }
                }, label: {
                    LibraryLabelView()
                })
                .onChange(of: self.settingData.selectLibrary, perform: { newvalue in
                    self.changeSelectLibrary()
                })
                .labelsHidden()
            }
        }, header: {
            HStack {
                Label("Library", systemImage: "ipod")
            }
        })
    }
    
    func changeSelectLibrary() {
        self.settingData.selectLibrary = self.music.matchSelectLibrary(selectLibrary: self.settingData.selectLibrary)
        self.settingData.save()
    }
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

struct AllSettingView: View {
    @EnvironmentObject var settingData: SettingData
    @EnvironmentObject var music: Music

    var body: some View {
        Section(header: Text("All")) {
            HStack {
                Toggle(isOn: self.$settingData.iCloud, label: {
                    Text("Use iCloud")
                })
                .onChange(of: self.settingData.iCloud, perform: { value in
                    print("Setting onChange:\(value)")
                    self.settingData.save()
                    self.music.setPlaylistList()
                })
            }
            HStack {
                Toggle(isOn: self.$settingData.autoPlay, label: {
                    Text("Auto play")
                })
                .onChange(of: self.settingData.autoPlay, perform: { value in
                    print("Setting onChange:\(value)")
                    self.settingData.save()
                })
            }
            HStack {
                Toggle(isOn: self.$settingData.hideSongTitle, label: {
                    Text("Hide song title")
                })
                .onChange(of: self.settingData.hideSongTitle, perform: { value in
                    print("Setting onChange:\(value)")
                    self.settingData.save()
                })
            }
            NavigationLink(destination: {
                FilterDispOnOffView()
            }, label: {
                Text("Show/hide filters")
            })
        }
    }
}

struct SongsSettingView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        Section(header: Label("Song select", systemImage: "music.note")) {
            NumberPlusMinusInputView(title: NSLocalizedString("Select song count", comment: ""), bounds: 1...100, number: self.$settingData.selectMusicCount)
                .onChange(of: self.settingData.selectMusicCount, perform: { value in
                    print("Setting onChange:\(value)")
                    self.settingData.save()
                })
        }
    }
}

struct AlbumSettingView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        Section(header: Label("Album Shuffle", systemImage: "opticaldisc")) {
            NumberPlusMinusInputView(title: NSLocalizedString("Select min tracks", comment: ""), bounds: 1...100, number: self.$settingData.selectAlbumMinTracks)
                .onChange(of: self.settingData.selectAlbumMinTracks, perform: { value in
                    print("Setting onChange:\(value)")
                    self.settingData.save()
                })
        }
    }
}

struct ReleaseYearSettingView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        Section(header: Label("Release Year", systemImage: "calendar")) {
            HStack {
                Text(Int(self.settingData.releaseYear).description)
                Slider(value: self.$settingData.releaseYear, in: 1950...2021, step: 1)
                    .onChange(of: self.settingData.releaseYear, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
            }
        }
    }
}

struct TimeLimitSettingFormView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        Section(header: HStack {
            Image(systemName: "timer")
            Text(NSLocalizedString("Time Limit", comment: "") +
                    "(" +
                    NSLocalizedString("min", comment: "") +
                    ")")
        })
        {
            HStack {
                Text(Int(self.settingData.timeLimit).description)
                Slider(value: self.$settingData.timeLimit, in: 10...180, step: 1)
                    .onChange(of: self.settingData.timeLimit, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
            }
        }
    }
}

struct CountView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        Section(header: HStack {
            Image(systemName: "textformat.123")
            Text("Count")
        })
        {
            NavigationLink("Play count", destination: PlayCountView(playCountMaps: self.music.countPlayCount()))
            NavigationLink("Release Year", destination: ReleaseYearCountView(releaseYearMaps: self.music.countReleaseYear()))
        }
        .onAppear(perform: {
        })
    }
}

struct AboutView: View {
    let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        Section(header: Text("About")) {
            VStack() {
                HStack {
                    Spacer()
                    Text("oto-sai")
//                        .font(.largeTitle)
                        .font(Font.custom("HiraMinProN-W6", size: 32))
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("Version \(version)")
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("cloudsquare")
                    Text("©️ 2021-2023 cloudsquare.jp")
                        .font(.footnote)
                    Spacer()
                }
            }
        }
    }
}
