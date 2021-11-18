//
//  FilterDispOnOffView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/11/17.
//

import SwiftUI

struct FilterDispOnOffView: View {
    var body: some View {
        List {
            ForEach(0..<FiltersView.filtersData.count) { index in
                Text(FiltersView.filtersData[index].1.rawValue)
            }
        }
        .navigationTitle("Show/hide filters")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FilterDispOnOffView_Previews: PreviewProvider {
    static var previews: some View {
        FilterDispOnOffView()
    }
}
