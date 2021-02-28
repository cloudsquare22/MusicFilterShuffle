//
//  FiltersView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/28.
//

import SwiftUI

struct FiltersView: View {
    @EnvironmentObject var music: Music
    
    @State var dispProgress = false
    @State var onTap = false

    var body: some View {
        NavigationView {
            List {
                if self.dispProgress == true {
                    HStack {
                        Spacer()
                        ProgressView("selecting music...")
                        Spacer()
                    }
                }
                FilterView(dispProgress: self.$dispProgress, onTap: self.$onTap, title: "Last Played Date Old", filter: 0)
                FilterView(dispProgress: self.$dispProgress, onTap: self.$onTap, title: "Play Count Min", filter: 1)
            }
            .padding(8.0)
            .navigationBarTitle("Filters", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView()
            .environmentObject(Music())
    }
}

struct FilterView: View {
    @EnvironmentObject var music: Music

    @Binding var dispProgress: Bool
    @Binding var onTap: Bool
    let title: String
    let filter: Int
    
    var body: some View {
        Text(self.title)
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            .onTapGesture {
                if self.onTap == false {
                    self.onTap = true
                    self.dispProgress.toggle()
                    DispatchQueue.global().async {
                        if self.filter == 0 {
                            self.music.lastPlayedDateOld()
                        }
                        else if self.filter == 1 {
                            self.music.playCountMin()
                        }
                        self.dispProgress.toggle()
                        self.onTap = false
                    }
                }
                else {
                    print("onTap Noaction!!")
                }
            }
    }
}
