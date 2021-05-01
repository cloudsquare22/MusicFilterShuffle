//
//  ManualView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/18.
//

import SwiftUI

struct ManualView: View {
    let manuals: [String] = [
        "Oldest song with last played date, except for unplayed songs.",
        "New song on last play date.",
        "Songs with a low number of plays.",
        "Songs with a large number of plays.",
        "Unplayed songs in the album.",
        "Songs with the specified release year.",
        "Shuffle all songs.",
        "All songs will be shuffled within the time limit."
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<FiltersView.filtersData.count) { index in
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text(NSLocalizedString(FiltersView.filtersData[index].0, comment: ""))
                            .font(.title2)
                        Text(NSLocalizedString(self.manuals[index], comment: ""))
                    }
                    .padding(8.0)
                }
            }
            .navigationBarTitle("Manual", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ManualView_Previews: PreviewProvider {
    static var previews: some View {
        ManualView()
    }
}
