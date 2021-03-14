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
    let filter: Music.Filter
    @State var dispPlay: Bool

    var body: some View {
        NavigationView {
            List {
                if self.filter == .albumshuffle || self.filter == .albumnotcomplete {
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
                    let item = self.music.playItems[index]
                    VStack(alignment: .leading) {
                        Text("\(item.title!)")
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
            .navigationBarTitle("Play Songs", displayMode: .inline)
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
        ItemsView(filter: Music.Filter.forgotten, dispPlay: true)
            .environmentObject(Music())
    }
}
