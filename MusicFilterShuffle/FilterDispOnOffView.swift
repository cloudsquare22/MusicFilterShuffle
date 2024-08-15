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
            ForEach(0..<FiltersView.filtersData.count, id: \.self) { index in
                HStack {
                    Text(NSLocalizedString(FiltersView.filtersData[index].0, comment: ""))
                        .font(.headline)
                    Spacer()
                    if self.settingData.filterDispOnOffMap[FiltersView.filtersData[index].1.rawValue] == false {
                        Image(systemName: "square")
                            .onTapGesture {
                                print("\(index) off")
                                self.settingData.filterDispOnOffMap[FiltersView.filtersData[index].1.rawValue] = true
                                self.settingData.save()
                            }
                            .font(.title)
                    }
                    else {
                        Image(systemName: "checkmark.square")
                            .onTapGesture {
                                print("\(index) on")
                                self.settingData.filterDispOnOffMap[FiltersView.filtersData[index].1.rawValue] = false
                                self.settingData.save()
                            }
                            .font(.title)
                    }
                }
            }
        }
        .navigationTitle("Show/hide filters")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct FilterDispOnOffView_Previews: PreviewProvider {
    static var previews: some View {
        FilterDispOnOffView()
            .environmentObject(SettingData())
    }
}
