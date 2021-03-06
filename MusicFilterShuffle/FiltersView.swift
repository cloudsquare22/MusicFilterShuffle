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

//    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var columns: [GridItem] = [GridItem(spacing: 16), GridItem(spacing: 16)]

    var body: some View {
        NavigationView {
            ScrollView {
                GeometryReader { geometry in
                    LazyVGrid(columns: columns) {
                        FilterView(onTap: self.$onTap, title: "Last Played Date Old", filter: 0, size: geometry.size.width)
                        FilterView(onTap: self.$onTap, title: "Play Count Min", filter: 1, size: geometry.size.width)
                    }
                    .padding(16)
                }
            }
            .navigationBarTitle("Filters", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        NavigationView {
//            List {
//                FilterView(onTap: self.$onTap, title: "Last Played Date Old", filter: 0)
//                FilterView(onTap: self.$onTap, title: "Play Count Min", filter: 1)
//            }
//            .padding(8.0)
//            .navigationBarTitle("Filters", displayMode: .inline)
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
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
    let title: String
    let filter: Int
    let size: CGFloat
    
    var body: some View {
        Text(self.title)
            .font(.title2)
            .fontWeight(.light)
            .padding(16)
            .frame(width: CGFloat(abs(size / 2 - 24)), height: CGFloat(abs(size / 2 - 24)), alignment: .center)
            .overlay(RoundedRectangle(cornerRadius: 32).stroke())
            .overlay(RoundedRectangle(cornerRadius: 32).foregroundColor(Color.gray.opacity(0.0000001))
            .overlay(OverlayProgressView(dispProgress: self.$dispProgress))
            .onTapGesture {
                if self.onTap == false {
                    self.onTap = true
                    self.dispProgress.toggle()
                    DispatchQueue.global().async {
                        if self.filter == 0 {
                            self.music.lastPlayedDateOld()
                        }
                        else if self.filter == 1 {
                            self.music.playCountMin(selectMusicCount: self.settingData.selectMusicCount)
                        }
                        if self.settingData.autoPlay == true {
                            self.music.play()
                        }
                        self.dispProgress.toggle()
                        self.onTap = false
                        self.disapItemsView.toggle()
                    }
                }
                else {
                    print("onTap Noaction!!")
                }
            }
            .onLongPressGesture {
                print("cc long")
                print("\(self.size)")
                print("\(abs(self.size / 2 - 16))")
            })
            .fullScreenCover(isPresented: self.$disapItemsView, onDismiss: {}, content: {
                ItemsView()
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
