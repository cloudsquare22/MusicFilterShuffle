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
    let filter: Music.Filter
    let title: String
    @State var dispPlay: Bool

    var body: some View {
        NavigationView {
            List {
                if self.filter == .albumshuffle || self.filter == .albumnotcomplete {
                    HStack {
                        Spacer()
                        if self.music.playItems.count > 0 {
                            VStack {
                                Text(self.music.playItems[0].albumTitle!)
                                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                let artwork = self.music.artwork(item: self.music.playItems[0])
                                artwork
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .clipShape(Circle())
                            }
                        }
                        Spacer()
                    }
                    .padding(16.0)
                }
                else if self.filter == .playtime {
                    HStack {
                        Spacer()
                        Text(self.music.totalTimeToString())
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        Spacer()
                    }
                }
                ForEach(0..<self.music.playItems.count, id: \.self) { index in
                    let item = self.music.playItems[index]
                    VStack(alignment: .leading) {
                        if self.settingData.hideSongTitle == false {
                            Text("\(item.title!)")
                        }
                        else {
                            Text("- Hidden by setting -")
                                .foregroundColor(.gray)
                        }
                        HStack(spacing: 0) {
                            switch self.filter {
                            case .oldday, .nowaday:
                                Text("Last Play")
                                    .foregroundColor(.gray)
                                Text(":" + "\(Util.dateDisp(date: item.lastPlayedDate!))")
                                    .foregroundColor(.gray)
                            default:
                                Text("Play Count")
                                    .foregroundColor(.gray)
                                Text(":\(item.playCount)")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if item.albumArtist != nil {
                                Text("\(item.albumArtist!)")
                            }
                            else {
                                Text("\(item.artist!)")
                            }
                        }
                        .font(.caption)
                    }
                }
                Spacer()
            }
            .padding(8.0)
            .listStyle(PlainListStyle())
            .overlay(Button(action: {
                self.music.play()
                self.dispPlay = false
            }, label: {
                if self.dispPlay == true {
                    Image(systemName: "play")
                        .font(Font.system(size: 48))
                        .padding(8.0)
                }
            }), alignment: .bottom)
            .navigationTitle(NSLocalizedString(self.title, comment: ""))
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark.circle")
                    .font(.title)
            }))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            print("ItemsView.onAppear")
//            if self.dispPlay == false {
//                self.music.play()
//            }
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(filter: Music.Filter.forgotten, title: "Test", dispPlay: true)
            .environmentObject(Music())
    }
}
