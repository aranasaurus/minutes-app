//
//  SessionTests.swift
//  Minutes
//
//  Created by Ryan Arana on 11/26/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import XCTest

@testable import Minutes

class SessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDuration() {
        let expected = TimeInterval(10)
        let startTime = Date(timeIntervalSinceNow: -3600)

        // Given a start and end time it should report the time between them
        XCTAssertEqual(Session(rate: 0, startTime: startTime, endTime: Date(timeInterval: expected, since: startTime)).duration, expected)

        // Given a start time and no end time it should report the time that has passed since the 
        // start time
        XCTAssertEqual(Session(rate: 0, startTime: startTime).duration, Date().timeIntervalSince(startTime), accuracy: 0.001)
    }

    func testCost() {
        let hour = Measurement(value: 1, unit: UnitDuration.hours)

        // A session with rate 0, should always have a cost of 0
        XCTAssertEqual(Session(rate: 0, startTime: Date(timeIntervalSinceReferenceDate: 0), endTime: Date()).cost, 0)

        let rate = Double(42)
        // A session with a rate should multiply that rate by the number of hours of the session.
        XCTAssertEqual(Session(rate: rate, startTime: Date(timeIntervalSinceNow: -hour.converted(to: .seconds).value)).cost, rate, accuracy: 0.001)
        XCTAssertEqual(Session(rate: rate, startTime: Date(timeIntervalSinceNow: -hour.converted(to: .seconds).value/2)).cost, rate/2, accuracy: 0.001)

    }

    func testDictionaryForSession() {
        var s = Session(rate: 42, startTime: Date(timeIntervalSinceNow: -3600), endTime: Date())
        var expected: [String: Any] = [
            Session.Keys.rate: s.rate,
            Session.Keys.startTime: s.startTime,
            Session.Keys.endTime: s.endTime!
        ]
        verify(Session.dictionary(for: s), with: expected)

        s = Session(rate: 42)
        expected = [
            Session.Keys.rate: s.rate,
            Session.Keys.startTime: s.startTime
        ]
        verify(Session.dictionary(for: s), with: expected)
    }

    func testParseFromDictionary() {
        let s = Session(rate: 42, startTime: Date(timeIntervalSinceNow: -3600), endTime: Date())
        let d = Session.dictionary(for: s)
        verify(Session.parse(from: d), with: d)
        verify(Session.parse(from: [d]).first, with: d)
    }

    private func verify(_ dict: [String: Any], with expected: [String: Any]) {
        XCTAssertEqual(dict[Session.Keys.rate] as? Double, expected[Session.Keys.rate] as? Double)
        XCTAssertEqual(dict[Session.Keys.startTime] as? Date, expected[Session.Keys.startTime] as? Date)
        XCTAssertEqual(dict[Session.Keys.endTime] as? Date, expected[Session.Keys.endTime] as? Date)
    }

    private func verify(_ session: Session?, with dict: [String: Any]) {
        guard let session = session else { XCTFail("Session was nil"); return }

        XCTAssertEqual(session.rate, dict[Session.Keys.rate] as? Double)
        XCTAssertEqual(session.startTime, dict[Session.Keys.startTime] as? Date)
        XCTAssertEqual(session.endTime, dict[Session.Keys.endTime] as? Date)
    }
}
