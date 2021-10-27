//
//  ReleaseYearCountView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/10/27.
//

import SwiftUI

struct ReleaseYearCountView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        List {
            ForEach(0..<self.music.releaseYearMaps.count) { index in
                HStack {
                    Text(self.music.releaseYearMaps[index].0)
                    Spacer()
                    Text(self.music.releaseYearMaps[index].1)
                }
            }
        }
        .navigationTitle("Release Year Count")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ReleaseYearCountView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseYearCountView()
    }
}
