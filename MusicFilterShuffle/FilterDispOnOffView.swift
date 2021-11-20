//
//  FilterDispOnOffView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/11/17.
//

import SwiftUI

struct FilterDispOnOffView: View {
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        List {
            ForEach(0..<FiltersView.filtersData.count) { index in
                HStack {
                    Text(FiltersView.filtersData[index].1.rawValue)
                    Spacer()
                    if self.settingData.filterDispOnOffMap[FiltersView.filtersData[index].1.rawValue] == false {
                        Image(systemName: "square")
                    }
                    else {
                        Image(systemName: "checkmark.square")
                    }
                }
                .font(.title)
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
