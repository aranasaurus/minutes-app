//
//  Tracker.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import UIKit

class Tracker {
    typealias DurationUpdateBlockType = (_ newValue: TimeInterval, _ oldValue: TimeInterval) -> Void
    var durationUpdateBlock: DurationUpdateBlockType?

    var duration: TimeInterval = 0 {
        didSet {
            durationUpdateBlock?(duration, oldValue)
        }
    }

    private(set) var referenceTime: Date? {
        didSet {
            // TODO: This is gross and should be done in a different way.
            UserDefaults.standard.set(referenceTime, forKey: "TrackerReferenceTime")
        }
    }
    private var timer: Timer?
    private var backgroundObserver: AnyObject?

    init(updateBlock: DurationUpdateBlockType?) {
        self.durationUpdateBlock = updateBlock
        self.referenceTime = UserDefaults.standard.object(forKey: "TrackerReferenceTime") as? Date
        self.duration = abs(referenceTime?.timeIntervalSinceNow ?? 0)

        backgroundObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationWillResignActive,
            object: nil, queue: nil
        ) { notification in
            self.referenceTime = Date()
        }
    }

    deinit {
        timer?.invalidate()
    }

    func start() {
        referenceTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            self.referenceTime = Date()
            self.duration.add(timer.timeInterval)
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        guard let referenceTime = referenceTime else { return }
        duration.add(abs(referenceTime.timeIntervalSinceNow))
        self.referenceTime = nil
    }
}
