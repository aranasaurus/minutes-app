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
        static let defaultRate = "defaultRate"
    }

    let identifier: Int
    var name: String
    var defaultRate: Double

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
    var cost: Double {
        return sessions.reduce(trackingSession?.cost ?? 0) { $0 + $1.cost }
    }

    init(identifier: Int, name: String, defaultRate: Double, sessions: [Session] = []) {
        self.identifier = identifier
        self.name = name
        self.sessions = sessions
        self.defaultRate = defaultRate
        
        super.init()

        refreshSessionStats()
    }

    func start() {
        trackingSession = Session(rate: defaultRate)
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
        let rate = aDecoder.decodeDouble(forKey: Keys.defaultRate)
        self.init(identifier: identifier, name: name, defaultRate: rate, sessions: sessions)

        if let trackingDict = aDecoder.decodeObject(forKey: Keys.trackingSession) as? [String: Any] {
            trackingSession = Session.parse(from: trackingDict)
        }
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(identifier, forKey: Keys.identifier)
        aCoder.encode(name, forKey: Keys.name)
        let sessions = self.sessions.map(Session.dictionary(for:))
        aCoder.encode(sessions, forKey: Keys.sessions)
        aCoder.encode(defaultRate, forKey: Keys.defaultRate)
        if let tracking = trackingSession {
            aCoder.encode(Session.dictionary(for: tracking), forKey: Keys.trackingSession)
        }
    }
}

extension Project: Storable {
    static var pluralName: String { return "projects" }
}

extension DataStore where DataType: Project {
    func generateSampleData(items: Int, save: Bool) {
        data.removeAll()
        for i in 0..<items {
            data.append(Project(identifier: i, name: "Project #\(i + 1)", defaultRate: 42) as! DataType)
        }
        if save { self.save() }
    }
}
