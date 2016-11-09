//
//  Project.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import Foundation

struct Project {
    struct Session {
        let rate: Double = 0
        let startTime: Date = Date()
        var endTime: Date? = nil

        var duration: TimeInterval {
            return abs(startTime.timeIntervalSince(endTime ?? Date()))
        }
    }

    let identifier: String
    let name: String
    let rate: Double

    var sessions: [Session] = [] {
        didSet {
            time = sessions.reduce(0) { $0 + $1.duration }
        }
    }

    private(set) var trackingSession: Session?
    private(set) var time: TimeInterval = 0

    init(identifier: String, name: String, rate: Double = 0, sessions: [Session] = []) {
        self.identifier = identifier
        self.name = name
        self.rate = rate
        self.sessions = sessions
    }

    mutating func start() {
        trackingSession = Session()
    }

    mutating func stop() {
        guard var session = trackingSession else { return }
        session.endTime = Date()
        sessions.append(session)
        trackingSession = nil
    }
}
