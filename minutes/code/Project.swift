//
//  Project.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import Foundation

class Project {
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
            recordedTime = sessions
                .filter { $0.endTime != nil }
                .reduce(0) { return $0 + $1.duration }
        }
    }
    var recordedTime: TimeInterval = 0
    var trackingTime: TimeInterval { return abs(trackingSession?.startTime.timeIntervalSinceNow ?? 0) }
    var totalTime: TimeInterval { return recordedTime + trackingTime }

    private(set) var trackingSession: Session?
    var isTracking: Bool { return trackingSession != nil }

    init(identifier: String, name: String, rate: Double = 0, sessions: [Session] = []) {
        self.identifier = identifier
        self.name = name
        self.rate = rate
        self.sessions = sessions
    }

    func start() {
        trackingSession = Session()
    }

    func stop() {
        guard var session = trackingSession else { return }
        session.endTime = Date()
        sessions.append(session)
        trackingSession = nil
    }
}

extension Project: Equatable { }
func ==(a: Project, b: Project) -> Bool {
    return a.identifier == b.identifier
}
