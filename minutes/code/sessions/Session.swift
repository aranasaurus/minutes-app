//
//  Session.swift
//  Minutes
//
//  Created by Ryan Arana on 11/19/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import Foundation

struct Session {
    struct Keys {
        static let rate = "rate"
        static let startTime = "startTime"
        static let endTime = "endTime"
    }
    let rate: Double
    let startTime: Date
    var endTime: Date?

    var duration: TimeInterval {
        return abs(startTime.timeIntervalSince(endTime ?? Date()))
    }

    var cost: Double { return Measurement(value: duration, unit: UnitDuration.seconds).converted(to: .hours).value * rate }

    init(rate: Double, startTime: Date = Date(), endTime: Date? = nil) {
        self.rate = rate
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension Session {
    static func dictionary(for session: Session) -> [String: Any] {
        var d: [String: Any] = [
            Keys.rate: session.rate,
            Keys.startTime: session.startTime
        ]
        if let end = session.endTime {
            d[Keys.endTime] = end
        }
        return d
    }

    static func parse(from dictionary: [String: Any]) -> Session? {
        guard
            let rate = dictionary[Keys.rate] as? Double,
            let startTime = dictionary[Keys.startTime] as? Date
            else { return nil }
        return Session(rate: rate, startTime: startTime, endTime: dictionary[Keys.endTime] as? Date)
    }

    static func parse(from array: [[String: Any]]) -> [Session] {
        return array.compactMap(Session.parse(from:))
    }
}
