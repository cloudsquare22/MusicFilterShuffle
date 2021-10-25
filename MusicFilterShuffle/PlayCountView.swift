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
                Text(self.music.playCountMaps[index])
            }
        }
    }
}

struct PlayCountView_Previews: PreviewProvider {
    static var previews: some View {
        PlayCountView()
    }
}
