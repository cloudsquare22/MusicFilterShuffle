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
                Section(header: HStack {
                    Image(systemName: "music.note")
                    Text("Song select")
                }) {
                    NumberPlusMinusInputView(title: "Select song count", bounds: 1...100, number: self.$settingData.selectMusicCount)
                        .onChange(of: self.settingData.selectMusicCount, perform: { value in
                            print("Setting onChange:\(value)")
                            self.settingData.save()
                        })
                }
                Section(header: HStack {
                    Image(systemName: "opticaldisc")
                    Text("Album select")
                })
                {
                    NumberPlusMinusInputView(title: "Select min tracks", bounds: 1...100, number: self.$settingData.selectAlbumMinTracks)
                        .onChange(of: self.settingData.selectAlbumMinTracks, perform: { value in
                            print("Setting onChange:\(value)")
                            self.settingData.save()
                        })
                }
                Section(header: HStack {
                     Text("Release Year")
                 })
                 {
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
