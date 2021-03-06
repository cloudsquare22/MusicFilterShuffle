//
//  SettingView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/28.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        NavigationView {
            Form {
                NavigationLink("Manual", destination: ManualView())
                AllSettingView()
                SongsSettingView()
                ReleaseYearSettingView()
                TimeLimitSettingView()
                AlbumSettingView()
                AboutView()
            }
            .navigationBarTitle("Setting", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            print("Setting onAppear")
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

struct AllSettingView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        Section(header: Text("All")) {
            HStack {
                Toggle(isOn: self.$settingData.iCloud, label: {
                    Text("Use iCloud")
                })
                .onChange(of: self.settingData.iCloud, perform: { value in
                    print("Setting onChange:\(value)")
                    self.settingData.save()
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

struct TimeLimitSettingView: View {
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
                    Text("©️ 2021 cloudsquare.jp")
                        .font(.footnote)
                    Spacer()
                }
            }
        }
    }
}
