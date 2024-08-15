//
//  ReleaseYearCountView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/10/27.
//

import SwiftUI

struct ReleaseYearCountView: View {
    var releaseYearMaps: [(String, String)]

    var body: some View {
        List {
            ForEach(0..<self.releaseYearMaps.count, id: \.self) { index in
                HStack {
                    Text(self.releaseYearMaps[index].0)
                    Spacer()
                    Text(self.releaseYearMaps[index].1)
                }
            }
        }
        .navigationTitle("Release Year")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct ReleaseYearCountView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseYearCountView(releaseYearMaps: [("1976", "2")])
    }
}
