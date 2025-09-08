//
//  FiltersView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/28.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData

    @State var onTap = false
    @State var tapSetting: Bool = false

    static let filtersData: [(UUID, String, Music.Filter, UIColor)] =
        [(UUID(), "A long time ago in a...", .oldday, .blue),
         (UUID(), "Nowadays", .nowaday, .brown),
         (UUID(), "Forgotten", .forgotten, .cyan),
         (UUID(), "Heavy Rotation", .heavyrotation, .magenta),
         (UUID(), "Album Play Complete", .albumnotcomplete, .orange),
         (UUID(), "Release", .release, .green),
         (UUID(), "Shuffle", .shuffle, .red),
         (UUID(), "Time Limit", .playtime, .purple),
         (UUID(), "Album Shuffle", .albumshuffle, .yellow)]
    
    static let filterDatas: [FilterData] = [
        FilterData(id: 1, title: "A long time ago in a...", description: "Old songs with last played date.", filter: .oldday, color: .blue),
        FilterData(id: 2, title: "Nowadays", description: "New songs with last played date.", filter: .nowaday, color: .brown),
        FilterData(id: 3, title: "Forgotten", description: "Songs with a low number of plays.", filter: .forgotten, color: .cyan),
        FilterData(id: 4, title: "Heavy Rotation", description: "Songs with a large number of plays.", filter: .heavyrotation, color: .indigo),
        FilterData(id: 5, title: "Album Play Complete", description: "Unplayed songs in the album.", filter: .albumnotcomplete, color: .orange),
        FilterData(id: 6, title: "Release", description: "Songs with the specified release year.", filter: .release, color: .green),
        FilterData(id: 7, title: "Shuffle", description: "Shuffle all songs.", filter: .shuffle, color: .red),
        FilterData(id: 8, title: "Time Limit", description: "Select songs to be played closer to the designated time.", filter: .playtime, color: .purple),
        FilterData(id: 9, title: "Album Shuffle", description: "Shuffle by album.", filter: .albumshuffle, color: .yellow),
    ]

    var body: some View {
        List(FiltersView.filterDatas) { filterData in
            HStack {
                Image(systemName: "opticaldisc")
                    .foregroundStyle(filterData.color)
                    .font(.title)
                VStack(alignment: .leading) {
                    Text("\(filterData.title)")
                        .font(.title)
                    Text("\(filterData.description)")
                }
            }
            .alignmentGuide(.listRowSeparatorLeading, computeValue: { _ in
                0
            })
        }
        //
//        GeometryReader { geometry in
//            let width = geometry.size.width
//            ScrollView {
//                LazyVGrid(columns: self.settingData.colums()) {
//                    ForEach(0..<FiltersView.filtersData.count, id: \.self) { index in
//                        if self.settingData.filterDispOnOffMap[FiltersView.filtersData[index].1.rawValue] == nil ||
//                            self.settingData.filterDispOnOffMap[FiltersView.filtersData[index].1.rawValue] == true{
//                            FilterView(onTap: self.$onTap,
//                                       title: FiltersView.filtersData[index].0,
//                                       filter: FiltersView.filtersData[index].1,
//                                       width: width, color: FiltersView.filtersData[index].2,
//                                       columns: self.settingData.colums().count)
//                        }
//                    }
//                    SettingMenuView(width: width,
//                                    columns: self.settingData.colums().count)
//                }
//                .padding(16)
//            }
//        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
            .environmentObject(Music())
            .environmentObject(SettingData())
    }
}

struct FilterView: View {
    @EnvironmentObject var music: Music
    @EnvironmentObject var settingData: SettingData
    @State var dispProgress: Bool = false
    @State var disapItemsView: Bool = false
    @State var onReleaseSettingView: Bool = false
    @State var onTimeLimitSettingView: Bool = false

    @Binding var onTap: Bool
    let title: String
    let filter: Music.Filter
    let width: CGFloat
    let color: UIColor
    let columns: Int
    
    var body: some View {
        let size = CGFloat(abs(width / CGFloat(columns) - 24))
        ZStack {
            Image(systemName: "opticaldisc")
                .resizable()
                .foregroundColor(Color(color).opacity(1.0))
        }
        .frame(width: size, height: size, alignment: .center)
        .overlay(Circle().foregroundColor(Color(UIColor.systemGray6).opacity(0.6)))
        .overlay(
            VStack(alignment: .center, spacing: 0) {
                Text(NSLocalizedString(self.title, comment: ""))
                    .fontWeight(.medium)
                if self.filter == .release {
                        Text(Int(self.settingData.releaseYear).description)
                            .fontWeight(.medium)
                }
                else if self.filter == .playtime {
                    Text(String(format: "%d", Int(self.settingData.timeLimit)) + NSLocalizedString("min", comment: ""))
                        .fontWeight(.medium)
                }
            }
            .font(.title2)
            .padding(16)

        )
        .overlay(OverlayProgressView(dispProgress: self.$dispProgress))
        .onTapGesture {
            if self.onTap == false {
                self.onTap = true
                self.dispProgress.toggle()
                DispatchQueue.global().async {
                    self.music.runFilter(filter: self.filter)
                    self.onTap = false
                    if self.settingData.autoPlay == true {
                        self.music.play()
                    }
                    self.dispProgress.toggle()
                    self.disapItemsView.toggle()
                }
            }
            else {
                print("onTap Noaction!!")
            }
        }
        .onLongPressGesture(perform: {
            print("onLongPressGesture")
            if self.filter == .release {
                self.onReleaseSettingView.toggle()
            }
            else if self.filter == .playtime {
                self.onTimeLimitSettingView.toggle()
            }
        })
        .fullScreenCover(isPresented: self.$disapItemsView, onDismiss: {
        }, content: {
            ItemsView(filter: self.filter,
                      title: self.title,
                      dispPlay: !self.settingData.autoPlay)
        })
        .sheet(isPresented: self.$onReleaseSettingView, content: {
            ReleaseSettingView()
        })
        .sheet(isPresented: self.$onTimeLimitSettingView, content: {
            TimeLimitSettingView()
        })
        .onAppear() {
            print("FilterVCiew onAppear")
            self.settingData.selectLibrarys = self.music.matchSelectLibrary(selectLibrarys: self.settingData.selectLibrarys)
        }
    }
}

struct OverlayProgressView: View {
    @Binding var dispProgress: Bool

    var body: some View {
        if self.dispProgress == true {
            HStack {
                Spacer()
                ProgressView("selecting music...")
                Spacer()
            }
        }
    }
}

struct SettingMenuView: View {
    let width: CGFloat

    @EnvironmentObject var settingData: SettingData
    @State var tapSetting: Bool = false
    let columns: Int

    var body: some View {
        let size = CGFloat(abs(width / CGFloat(columns) - 24))
        Image(systemName: "gearshape")
            .resizable()
            .foregroundColor(Color(UIColor.gray).opacity(0.5))
            .frame(width: size, height: size, alignment: .center)
            .onTapGesture {
                self.tapSetting.toggle()
            }
            .sheet(isPresented: self.$tapSetting, content: {
                SettingView()
                    .environmentObject(self.settingData)
            })
    }
}

struct FilterData: Identifiable {
    var id: Int
    var title: String
    var description: String
    var filter: Music.Filter
    var color: Color
}
