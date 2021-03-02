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

    var body: some View {
        NavigationView {
            List {
                FilterView(onTap: self.$onTap, title: "Last Played Date Old", filter: 0)
                FilterView(onTap: self.$onTap, title: "Play Count Min", filter: 1)
            }
            .padding(8.0)
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

    @Binding var onTap: Bool
    let title: String
    let filter: Int
    
    var body: some View {
        HStack {
            Text(self.title)
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    if self.onTap == false {
                        self.onTap = true
                        self.dispProgress.toggle()
                        DispatchQueue.global().async {
                            if self.filter == 0 {
                                self.music.lastPlayedDateOld()
                            }
                            else if self.filter == 1 {
                                self.music.playCountMin(selectMusicCount: self.settingData.selectMusicCount)
                            }
                            self.dispProgress.toggle()
                            self.onTap = false
                        }
                    }
                    else {
                        print("onTap Noaction!!")
                    }
                }
            Spacer()
        }
        .overlay(OverlayProgressView(dispProgress: self.$dispProgress))
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
