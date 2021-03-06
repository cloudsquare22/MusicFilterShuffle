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

    var body: some View {
        NavigationView {
            List {
                if self.settingData.autoPlay == false {
                    HStack {
                        Spacer()
                        Image(systemName: "play.fill")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                            .onTapGesture {
                                self.music.play()
                            }
                        Spacer()
                    }
                }
                ForEach(0..<self.music.items.count) { index in
                    VStack(alignment: .leading) {
                        Text("\(self.music.items[index].title!)")
                        if self.music.items[index].albumArtist != nil {
                            Text("\(self.music.items[index].albumArtist!)")
                                .font(.caption)
                        }
                        else {
                            Text("\(self.music.items[index].artist!)")
                                .font(.caption)
                        }
                    }
                }
                if self.settingData.autoPlay == false {
                    HStack {
                        Spacer()
                        Image(systemName: "play.fill")
                            .foregroundColor(.blue)
                            .font(.largeTitle)
                            .onTapGesture {
                                self.music.play()
                        }
                        Spacer()
                    }
                }
            }
            .padding(8.0)
            .overlay(Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.largeTitle)
                    .padding(8.0)
            }), alignment: .bottom)
            .navigationBarTitle("Items", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                self.presentationMode.wrappedValue.dismiss()
//            }, label: {
//                Image(systemName: "xmark")
//                    .font(.title2)
//            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
            .environmentObject(Music())
            .environmentObject(SettingData())
    }
}
