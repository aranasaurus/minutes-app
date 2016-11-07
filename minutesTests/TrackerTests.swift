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
        UserDefaults.standard.removeObject(forKey: "test_TrackerReferenceTime")
        UserDefaults.standard.removeObject(forKey: "test_TrackerDuration")
        UserDefaults.standard.removeObject(forKey: "test_IsTracking")
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "test_TrackerReferenceTime")
        UserDefaults.standard.removeObject(forKey: "test_TrackerDuration")
        UserDefaults.standard.removeObject(forKey: "test_IsTracking")
        super.tearDown()
    }
    
    func testStart() {
        var exp: XCTestExpectation? = expectation(description: "tracker updated")
        let testStart = NSDate()
        let testDuration = TimeInterval(3)
        let tracker = Tracker(identifier: "test") { new, old in
            guard abs(testStart.timeIntervalSinceNow) >= testDuration else { return }
            exp?.fulfill()
            exp = nil
        }

        tracker.start()
        XCTAssertNotNil(tracker.referenceTime)

        waitForExpectations(timeout: testDuration + 1, handler: nil)

        XCTAssertNotNil(tracker.referenceTime)
        XCTAssertEqualWithAccuracy(tracker.duration, testDuration, accuracy: 0.1)
    }

    func testStop() {
        let exp = expectation(description: "tracker updated")
        let duration: TimeInterval = 1
        let tracker = Tracker(identifier: "test") { new, old in
            guard new >= duration else { return }
            exp.fulfill()
        }

        let started = Date()
        tracker.start()
        waitForExpectations(timeout: 2, handler: nil)

        // Sanity check
        XCTAssertNotNil(tracker.referenceTime)
        XCTAssertEqualWithAccuracy(tracker.duration, 1, accuracy: 0.1)

        let exp2 = expectation(description: "tracker updated from stop")
        var fulfilled = false
        tracker.durationUpdateBlock = { new, old in
            guard !fulfilled else { return }
            exp2.fulfill()
            fulfilled = true
        }
        let stopped = Date()
        tracker.stop()

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqualWithAccuracy(abs(stopped.timeIntervalSince(started)), tracker.duration, accuracy: 0.1)
    }

    func testTrackerRestoration() {
        let storedDuration = Double(42)
        var storedDate = Date(timeIntervalSinceNow: -storedDuration)
        UserDefaults.standard.set(storedDate, forKey: "test_TrackerReferenceTime")
        UserDefaults.standard.set(storedDuration, forKey: "test_TrackerDuration")

        let tracker = Tracker(identifier: "test", updateBlock: nil)
        XCTAssertEqualWithAccuracy(tracker.duration, storedDuration, accuracy: 0.1)
        XCTAssertEqual(tracker.referenceTime, storedDate)

        let exp = expectation(description: "tracker update")
        tracker.durationUpdateBlock = { new, old in
            guard new > storedDuration else { return }
            exp.fulfill()
        }

        tracker.start()
        let expectedDuration = storedDuration + abs(storedDate.timeIntervalSinceNow)
        XCTAssertEqualWithAccuracy(tracker.duration, expectedDuration, accuracy: 0.1)
        XCTAssertNotEqual(tracker.referenceTime, storedDate)

        waitForExpectations(timeout: 1.5, handler: nil)
        XCTAssertEqualWithAccuracy(tracker.duration, expectedDuration, accuracy: 0.75)
        XCTAssertNotEqual(tracker.referenceTime, storedDate)
        storedDate = UserDefaults.standard.object(forKey: "test_TrackerReferenceTime") as? Date ?? storedDate
        XCTAssertEqual(tracker.referenceTime, storedDate)
    }

    func testMultipleTrackersDontStepOnEachOther() {
        UserDefaults.standard.removeObject(forKey: "1st_TrackerReferenceTime")
        UserDefaults.standard.removeObject(forKey: "1st_TrackerDuration")
        UserDefaults.standard.removeObject(forKey: "2nd_TrackerReferenceTime")
        UserDefaults.standard.removeObject(forKey: "2nd_TrackerDuration")

        let startDuration = Double(42)
        let startDate = Date(timeIntervalSinceNow: -startDuration)
        let testDuration = Double(3)
        let expectedDuration = startDuration * 2 + testDuration
        UserDefaults.standard.set(startDate, forKey: "1st_TrackerReferenceTime")
        UserDefaults.standard.set(startDuration, forKey: "1st_TrackerDuration")

        let exp = expectation(description: "1st")
        var fulfilled = false
        let tracker1 = Tracker(identifier: "1st") { new, old in
            XCTAssertGreaterThan(new, startDuration)
            XCTAssertGreaterThanOrEqual(old, startDuration)

            guard new >= expectedDuration && !fulfilled else { return }
            exp.fulfill()
            fulfilled = true
        }

        let tracker2 = Tracker(identifier: "2nd", updateBlock: nil)

        tracker1.start()
        tracker2.start()

        waitForExpectations(timeout: 7, handler: nil)

        tracker1.stop()
        XCTAssertEqualWithAccuracy(tracker1.duration, expectedDuration, accuracy: 0.1)

        let exp2 = expectation(description: "2nd")
        fulfilled = false
        tracker2.durationUpdateBlock =  { new, old in
            XCTAssertLessThan(new, startDuration)
            XCTAssertLessThan(old, startDuration)

            guard new >= testDuration && !fulfilled else { return }
            exp2.fulfill()
            fulfilled = true
        }

        waitForExpectations(timeout: 2, handler: nil)

        tracker2.stop()
        XCTAssertEqualWithAccuracy(tracker2.duration, testDuration + 1, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(tracker1.duration, expectedDuration, accuracy: 0.1)
    }
}
