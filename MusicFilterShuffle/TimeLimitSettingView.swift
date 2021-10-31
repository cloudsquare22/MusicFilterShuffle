//
//  TimeLimitSettingView.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/10/31.
//

import SwiftUI

struct TimeLimitSettingView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settingData: SettingData

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Label("Time Limit", systemImage: "timer")
                    .font(.largeTitle)
                Text(Int(self.settingData.timeLimit).description)
                    .font(.title)
                    .padding(16.0)
                Slider(value: self.$settingData.timeLimit, in: 10...180, step: 1)
                    .onChange(of: self.settingData.timeLimit, perform: { value in
                        print("Setting onChange:\(value)")
                        self.settingData.save()
                    })
            }
            .padding(8)
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

struct TimeLimitSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TimeLimitSettingView()
            .environmentObject(SettingData())
    }
}
