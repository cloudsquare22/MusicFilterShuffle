//
//  ContentView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/02/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var music: Music

    var body: some View {
        VStack {
            Text("Count Min Filter")
                .padding()
            Button(action: {
                self.music.countMinFilter()
            }, label: {
                Text("Filter")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Music())
    }
}
