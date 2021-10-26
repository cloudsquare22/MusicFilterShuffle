//
//  PlayCountView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/10/25.
//

import SwiftUI

struct PlayCountView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        List {
            ForEach(0..<self.music.playCountMaps.count) { index in
                HStack {
                    Text(self.music.playCountMaps[index].0)
                    Spacer()
                    Text(self.music.playCountMaps[index].1)
                }
            }
        }
        .navigationTitle("Play Count")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PlayCountView_Previews: PreviewProvider {
    static var previews: some View {
        PlayCountView()
    }
}
