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

    var columns: [GridItem] = [GridItem(spacing: 16), GridItem(spacing: 16)]
    
    let filtersData: [(String, String, Music.Filter, UIColor)] =
        [("music.note", "A long time ago in a...", .oldday, .blue),
         ("music.note", "Nowadays", .nowaday, .brown),
         ("music.note", "Forgotten", .forgotten, .cyan),
         ("music.note", "Heavy Rotation", .heavyrotation, .green),
         ("opticaldisc", "Album Shuffle", .albumshuffle, .magenta),
         ("music.note.list", "Album Not Complete", .albumnotcomplete, .orange),
         ("music.note", "Release", .release, .red)]

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(0..<filtersData.count) { index in
                        FilterView(onTap: self.$onTap, imageName: self.filtersData[index].0, title: self.filtersData[index].1, filter: self.filtersData[index].2, size: geometry.size.width, color: self.filtersData[index].3)
                    }
                }
                .padding(16)
            }
        }
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

    @Binding var onTap: Bool
    let imageName: String
    let title: String
    let filter: Music.Filter
    let size: CGFloat
    let color: UIColor
    
    var body: some View {
        ZStack {
            Image(systemName: "opticaldisc").resizable().foregroundColor(Color(color).opacity(0.5))
            VStack(spacing: 8) {
//                Image(systemName: imageName)
                Text(self.title)
                    .fontWeight(.regular).background(Color(UIColor.systemGray6).opacity(0.5))
                if self.filter == .release {
                    HStack {
                        Image(systemName: "gearshape")
                            .font(Font.system(size: 16))
                            .foregroundColor(.gray)
                        Text(Int(self.settingData.releaseYear).description)
                    }
                    .background(Color(UIColor.systemGray6).opacity(0.5))
                }
            }
            .font(.title2)
            .padding(16)
        }
            .frame(width: CGFloat(abs(size / 2 - 24)), height: CGFloat(abs(size / 2 - 24)), alignment: .center)
//            .overlay(RoundedRectangle(cornerRadius: 32).foregroundColor(Color.gray.opacity(0.0000001)))
//            .overlay(RoundedRectangle(cornerRadius: 32).stroke().foregroundColor(Color(color)))
            .overlay(OverlayProgressView(dispProgress: self.$dispProgress))
    //        .overlay(OverlaySettingView(filter: self.filter), alignment: .bottomTrailing)
            .onTapGesture {
                if self.onTap == false {
                    self.onTap = true
                    self.dispProgress.toggle()
                    DispatchQueue.global().async {
                        self.music.runFilter(filter: self.filter)
                        self.dispProgress.toggle()
                        self.onTap = false
                        self.disapItemsView.toggle()
                    }
                }
                else {
                    print("onTap Noaction!!")
                }
            }
            .fullScreenCover(isPresented: self.$disapItemsView, onDismiss: {
            }, content: {
                switch self.filter {
                case .albumshuffle, .albumnotcomplete:
                    ItemsView(isAlbum: true, dispPlay: !self.settingData.autoPlay)
                default:
                    ItemsView(isAlbum: false, dispPlay: !self.settingData.autoPlay)
                }
        })
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

struct OverlaySettingView: View {
    let filter: Music.Filter

    var body: some View {
        if self.filter == .release {
            Image(systemName: "gearshape")
                .font(Font.system(size: 24))
                .foregroundColor(.gray)
                .padding(8)
        }
    }
}
