//
//  Util.swift
//  MusicFilterShuffle
//
//  Created by Shin Inaba on 2021/03/14.
//

import Foundation

class Util {
    static func dateDisp(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = .current
        return dateFormatter.string(from: date)
    }
}
