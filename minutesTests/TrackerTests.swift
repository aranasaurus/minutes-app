//
//  TrackerTests.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import XCTest
@testable import Minutes

class TrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "TrackerReferenceTime")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "TrackerReferenceTime")
        super.tearDown()
    }
    
    func testStart() {
        var exp: XCTestExpectation? = expectation(description: "tracker updated")
        var updatesReceived = 0
        let tracker = Tracker() { new, old in
            updatesReceived += 1

            guard updatesReceived > 3 else { return }
            exp?.fulfill()
            exp = nil
        }

        tracker.start()
        XCTAssertNotNil(tracker.referenceTime)

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(tracker.referenceTime)
        XCTAssertEqual(tracker.duration, 4)
    }

    func testStop() {
        let exp = expectation(description: "tracker updated")
        let duration: TimeInterval = 1
        let tracker = Tracker() { new, old in
            guard new >= duration else { return }
            exp.fulfill()
        }

        let started = Date()
        tracker.start()
        waitForExpectations(timeout: 2, handler: nil)

        // Sanity check
        XCTAssertNotNil(tracker.referenceTime)
        XCTAssertEqual(tracker.duration, 1)

        let exp2 = expectation(description: "tracker updated from stop")
        tracker.durationUpdateBlock = { new, old in
            exp2.fulfill()
        }
        let stopped = Date()
        tracker.stop()

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqualWithAccuracy(abs(stopped.timeIntervalSince(started)), tracker.duration, accuracy: 0.1)
    }

    func testTrackerRestoration() {
        let storedDuration = Double(42)
        var storedDate = Date(timeIntervalSinceNow: -storedDuration)
        UserDefaults.standard.set(storedDate, forKey: "TrackerReferenceTime")

        let tracker = Tracker(updateBlock: nil)
        XCTAssertEqualWithAccuracy(tracker.duration, storedDuration, accuracy: 0.1)
        XCTAssertEqual(tracker.referenceTime, storedDate)

        let exp = expectation(description: "tracker update")
        tracker.durationUpdateBlock = { new, old in
            guard new > storedDuration else { return }
            exp.fulfill()
        }

        tracker.start()
        XCTAssertEqualWithAccuracy(tracker.duration, storedDuration, accuracy: 0.1)
        XCTAssertNotEqual(tracker.referenceTime, storedDate)

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqualWithAccuracy(tracker.duration, storedDuration+1, accuracy: 0.5)
        XCTAssertNotEqual(tracker.referenceTime, storedDate)
        storedDate = UserDefaults.standard.object(forKey: "TrackerReferenceTime") as? Date ?? storedDate
        XCTAssertEqual(tracker.referenceTime, storedDate)
    }
}
