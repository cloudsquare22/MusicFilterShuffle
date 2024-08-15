//
//  PlayCountView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/10/25.
//

import SwiftUI

struct PlayCountView: View {
    var playCountMaps: [(String, String)]

    var body: some View {
        List {
            ForEach(0..<self.playCountMaps.count, id: \.self) { index in
                HStack {
                    Text(self.playCountMaps[index].0)
                    Spacer()
                    Text(self.playCountMaps[index].1)
                }
            }
        }
        .navigationTitle("Play Count")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct PlayCountView_Previews: PreviewProvider {
    static var previews: some View {
        PlayCountView(playCountMaps: [("10", "10")])
    }
}
