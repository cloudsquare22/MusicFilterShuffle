//
//  SettingView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/28.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        NavigationView {
            Form {
                NumberPlusMinusInputView(title: "Select music count", bounds: 1...100, number: self.$settingData.selectMusicCount)
                    .onChange(of: self.settingData.selectMusicCount, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
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
                    Toggle(isOn: self.$settingData.iCloud, label: {
                        Text("Use iCloud")
                    })
                    .onChange(of: self.settingData.iCloud, perform: { value in
                        print("Setting onChange:\(value)")
                        self.music.iCloud = value
                        self.settingData.save()
                    })
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
            .environmentObject(Music())
            .environmentObject(SettingData())
    }
}
