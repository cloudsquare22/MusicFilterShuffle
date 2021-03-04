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

    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        NavigationView {
            ScrollView {
                GeometryReader { geometry in
                    LazyVGrid(columns: columns) {
                        FilterView(onTap: self.$onTap, title: "Last Played Date Old", filter: 0)
                            .frame(width: geometry.size.width / 2, height: geometry.size.width, alignment: .center)
                        FilterView(onTap: self.$onTap, title: "Play Count Min", filter: 1)
                            .frame(width: geometry.size.width / 2, height: geometry.size.width, alignment: .center)
                    }
                    .padding(8.0)
                }
            }
            .padding(8.0)
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
    
    var body: some View {
        HStack {
            Text(self.title)
                .font(.title2)
                .fontWeight(.light)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .background(Image(systemName: "play").resizable().aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/))
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
        }
        .padding(8.0)
        .overlay(OverlayProgressView(dispProgress: self.$dispProgress))
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
