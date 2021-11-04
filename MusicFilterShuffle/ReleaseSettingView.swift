//
//  ReleaseSettingView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/10.
//

import SwiftUI

struct ReleaseSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Label("Release Year", systemImage: "calendar.circle")
                    .font(.largeTitle)
                Text(Int(self.settingData.releaseYear).description)
                    .font(.title)
                    .padding(16.0)
                Slider(value: self.$settingData.releaseYear, in: 1950...self.settingData.currentYear, step: 1)
                    .onChange(of: self.settingData.releaseYear, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
                    .padding(16.0)
            }
            Spacer()
        }
        .overlay(Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.circle")
                .font(Font.system(size: 48))
                .padding(8.0)
        }), alignment: .bottom)
    }
}

struct ReleaseSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseSettingView()
            .environmentObject(SettingData())
    }
}
