//
//  ProjectTests.swift
//  Minutes
//
//  Created by Ryan Arana on 11/26/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import XCTest

@testable import Minutes

class ProjectTests: XCTestCase {
    var project: Project!
    var session: Session!

    override func setUp() {
        super.setUp()

        session = Session(rate: 0, startTime: Date(timeIntervalSinceNow: -3600), endTime: Date())
        project = Project(
            identifier: 0,
            name: "test",
            defaultRate: 42,
            sessions: [session]
        )
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStartStop() {
        XCTAssertFalse(project.isTracking)
        XCTAssertEqual(project.totalTime, session.duration)
        XCTAssertEqual(project.recordedTime, session.duration)

        project.start()
        XCTAssert(project.isTracking)
        sleep(1)
        XCTAssertEqual(project.totalTime, session.duration + 1, accuracy: 0.01)
        XCTAssertGreaterThan(project.totalTime, project.recordedTime)

        project.stop()
        XCTAssertFalse(project.isTracking)
        XCTAssertEqual(project.totalTime, project.recordedTime)
        XCTAssertGreaterThan(project.totalTime, session.duration)
    }

    func testCost() {
        let sessions: [Session] = [
            session,
            Session(rate: 42, startTime: Date(timeIntervalSinceNow: -7200), endTime: Date(timeIntervalSinceNow: -3600))
        ]
        project.sessions = sessions
        // A session with a rate of 0 should not be counted in the cost calc
        XCTAssertEqual(project.cost, sessions.last!.cost)

        project.start()
        sleep(1)
        // The tracking session should get its rate from the default rate and it should be included in the total cost while it's tracking.
        XCTAssertEqual(project.cost, sessions.last!.cost + project.defaultRate/3600, accuracy: 0.01)
    }
}
