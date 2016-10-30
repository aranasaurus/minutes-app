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
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStart() {
        let exp = expectation(description: "tracker updated")
        var updatesReceived = 0
        let tracker = Tracker() { new, old in
            updatesReceived += 1

            guard updatesReceived > 3 else { return }
            exp.fulfill()
        }

        tracker.start()
        XCTAssertNotNil(tracker.referenceTime)

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertNotNil(tracker.referenceTime)
        XCTAssertEqual(tracker.duration, 4)
    }

    func testStop() {
        let exp = expectation(description: "tracker updated")
        let tracker = Tracker() { new, old in
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
}
