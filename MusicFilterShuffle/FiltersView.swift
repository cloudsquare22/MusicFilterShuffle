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
                Text("Last Played Date Old")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if self.onTap == false {
                            self.onTap = true
                            self.dispProgress.toggle()
                            DispatchQueue.global().async {
                                self.music.lastPlayedDateOld()
                                self.dispProgress.toggle()
                                self.onTap = false
                            }
                        }
                        else {
                            print("onTap Noaction!!")
                        }
                    }
                Text("Play Count Min")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        if self.onTap == false {
                            self.onTap = true
                            self.dispProgress.toggle()
                            DispatchQueue.global().async {
                                self.music.playCountMin()
                                self.dispProgress.toggle()
                                self.onTap = false
                            }
                        }
                        else {
                            print("onTap Noaction!!")
                        }
                    }
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
