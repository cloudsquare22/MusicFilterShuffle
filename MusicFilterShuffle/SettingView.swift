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
                NumberPlusMinusInputView(title: "選択曲数", bounds: 1...30, number: self.$settingData.selectMusicCount)
                    .onChange(of: self.settingData.selectMusicCount, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
                HStack {
                    Toggle(isOn: self.$settingData.autoPlay, label: {
                        Text("自動再生")
                    })
                    .onChange(of: self.settingData.autoPlay, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
                }
            }
            .padding(8.0)
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
