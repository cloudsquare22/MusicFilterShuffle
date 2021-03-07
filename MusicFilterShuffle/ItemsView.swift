//
//  ItemsView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/04.
//

import SwiftUI

struct ItemsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData
    let isAlbum:Bool

    var body: some View {
        NavigationView {
            List {
                if self.isAlbum == true {
                    HStack {
                        Spacer()
                        if self.music.playItems.count > 0 {
                            Text(self.music.playItems[0].albumTitle!)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                    }
                }
                ForEach(0..<self.music.playItems.count) { index in
                    VStack(alignment: .leading) {
                        Text("\(self.music.playItems[index].title!)")
                        if self.music.playItems[index].albumArtist != nil {
                            Text("\(self.music.playItems[index].albumArtist!)")
                                .font(.caption)
                        }
                        else {
                            Text("\(self.music.playItems[index].artist!)")
                                .font(.caption)
                        }
                    }
                }
                Spacer()
            }
            .padding(8.0)
            .overlay(Button(action: {
                    self.music.play()
            }, label: {
                if self.settingData.autoPlay == false {
                    Image(systemName: "play")
                        .font(Font.system(size: 48))
                        .padding(8.0)
                }
            }), alignment: .bottom)
            .navigationBarTitle("Items", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(isAlbum: false)
            .environmentObject(Music())
            .environmentObject(SettingData())
    }
}
