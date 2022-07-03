//
//  DateExtension.swift
//  TwitterLite
//
//  Created by Rahul Singh on 03/07/22.
//

import Foundation


extension Date {
    static func getDate(from interval: TimeInterval) -> String {
        let calendar = Calendar.current
        let date = Date(timeIntervalSince1970: interval)

        var dateStringValue = " -- "
        let formatter = DateFormatter()
        formatter.timeStyle = .short

        if calendar.isDateInYesterday(date) {
            formatter.dateStyle = .none

            dateStringValue = "Yesterday at \(formatter.string(from: date))"
        } else if calendar.isDateInToday(date) {
            formatter.dateStyle = .none

            dateStringValue = formatter.string(from: date)
        } else {
            formatter.dateStyle = .medium

            dateStringValue = formatter.string(from: date)
        }

        return dateStringValue
    }
}
