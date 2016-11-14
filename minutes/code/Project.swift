//
//  Project.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import Foundation

final class Project: NSObject {
    struct Keys {
        static let identifier = "identifier"
        static let name = "name"
        static let sessions = "sessions"
        static let trackingSession = "trackingSession"
    }

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

        init(rate: Double = 0, startTime: Date = Date(), endTime: Date? = nil) {
            self.rate = rate
            self.startTime = startTime
            self.endTime = endTime
        }
    }

    let identifier: Int
    let name: String

    var sessions: [Session] = [] {
        didSet {
            refreshSessionStats()
        }
    }
    var sessionsByStartDate: [Session] = []
    var recordedTime: TimeInterval = 0
    fileprivate(set) var trackingSession: Session?

    var trackingTime: TimeInterval { return abs(trackingSession?.startTime.timeIntervalSinceNow ?? 0) }
    var totalTime: TimeInterval { return recordedTime + trackingTime }
    var isTracking: Bool { return trackingSession != nil }

    init(identifier: Int, name: String, sessions: [Session] = []) {
        self.identifier = identifier
        self.name = name
        self.sessions = sessions

        super.init()

        refreshSessionStats()
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

    private func refreshSessionStats() {
        recordedTime = sessions
            .filter { $0.endTime != nil }
            .reduce(0) { return $0 + $1.duration }
        sessionsByStartDate = sessions.sorted { a, b in
            return a.startTime < b.startTime
        }
    }
}

extension Project: NSCoding {
    convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.name) as? String else { return nil }

        let identifier = aDecoder.decodeInteger(forKey: Keys.identifier)
        let sessions = Session.parse(from: aDecoder.decodeObject(forKey: Keys.sessions) as? [[String: Any]] ?? [])
        self.init(identifier: identifier, name: name, sessions: sessions)

        if let trackingDict = aDecoder.decodeObject(forKey: Keys.trackingSession) as? [String: Any] {
            trackingSession = Session.parse(from: trackingDict)
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: Keys.identifier)
        aCoder.encode(name, forKey: Keys.name)
        let sessions = self.sessions.map(Session.dictionary(for:))
        aCoder.encode(sessions, forKey: Keys.sessions)
        if let tracking = trackingSession {
            aCoder.encode(Session.dictionary(for: tracking), forKey: Keys.trackingSession)
        }
    }
}

extension Project.Session {
    static func dictionary(for session: Project.Session) -> [String: Any] {
        var d: [String: Any] = [
            Keys.rate: session.rate,
            Keys.startTime: session.startTime
        ]
        if let end = session.endTime {
            d[Keys.endTime] = end
        }
        return d
    }

    static func parse(from dictionary: [String: Any]) -> Project.Session? {
        guard
            let rate = dictionary[Keys.rate] as? Double,
            let startTime = dictionary[Keys.startTime] as? Date
            else { return nil }
        return Project.Session(rate: rate, startTime: startTime, endTime: dictionary[Keys.endTime] as? Date)
    }

    static func parse(from array: [[String: Any]]) -> [Project.Session] {
        return array.flatMap(Project.Session.parse(from:))
    }
}

extension Project: Storable {
    static var pluralName: String { return "projects" }
}

extension DataStore where DataType: Project {
    func generateSampleData(items: Int, save: Bool) {
        for i in 0..<items {
            data.append(Project(identifier: i, name: "Project #\(i + 1)") as! DataType)
        }
        if save { self.save() }
    }
}
