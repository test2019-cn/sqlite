//
//  String+Date.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2019/11/23.
//  Copyright © 2019 wistron. All rights reserved.
//

import Foundation

extension String {

    public func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "en_GB")
        return dateFormatter.date(from: self)
    }

    public func toMonday() -> String? {
        return self.toDate()?.monday?.shortDay
    }

    public func add(days: Int) -> String {
        var dateComponent = DateComponents()
        dateComponent.day = days
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let currentDate = dateFormatter.date(from: self),
            let nextDay = Calendar.current.date(byAdding: dateComponent, to: currentDate) else {
            return "Error \(self)"
        }
        return nextDay.shortDay ?? "Error \(self)"
    }

    public func toHours() -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHHH:mm:ss"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US")
        guard let date = dateFormatter.date(from: self),
            let baseDate = dateFormatter.date(from: "0000:00:00") else {
                return nil
        }
        return date.timeIntervalSince(baseDate) / 3600.0
    }
}

extension Date {

    public var shortDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self)
    }

    public var shortDay: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }

    public var changeToSystemTimeZone: Date? {
        let from = TimeZone(abbreviation: "UTC")
        let to = TimeZone.current
        guard let sourceOffset = from?.secondsFromGMT(for: self) else {
            return self
        }
        let destinationOffset = to.secondsFromGMT(for: self)
        let timeInterval = TimeInterval(destinationOffset - sourceOffset)
        return Date(timeInterval: timeInterval, since: self)
    }

    public var monday: Date? {
        return self.next(weekday: .monday, direction: .backward)
    }
}
