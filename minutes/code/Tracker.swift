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

    let identifier: String

    var duration: TimeInterval = 0 {
        didSet {
            durationUpdateBlock?(duration, oldValue)
            UserDefaults.standard.set(duration, forKey: "\(identifier)_TrackerDuration")
        }
    }

    var isTracking: Bool = false {
        didSet {
            UserDefaults.standard.set(isTracking, forKey: "\(identifier)_IsTracking")
        }
    }

    private(set) var referenceTime: Date? {
        didSet {
            guard referenceTime != oldValue else { return }
            
            // TODO: This is gross and should be done in a different way.
            UserDefaults.standard.set(referenceTime, forKey: "\(identifier)_TrackerReferenceTime")

            guard let prev = oldValue else { return }
            self.duration.add(abs(prev.timeIntervalSinceNow))
        }
    }
    private var timer: Timer?
    private var backgroundObserver: AnyObject?
    private var activeObserver: AnyObject?

    init(identifier: String, updateBlock: DurationUpdateBlockType?) {
        self.identifier = identifier
        self.durationUpdateBlock = updateBlock
        self.referenceTime = UserDefaults.standard.object(forKey: "\(identifier)_TrackerReferenceTime") as? Date
        self.duration = UserDefaults.standard.object(forKey: "\(identifier)_TrackerDuration") as? Double ?? 0
        self.isTracking = UserDefaults.standard.object(forKey: "\(identifier)_IsTracking") as? Bool ?? false
        if self.isTracking {
            self.start()
        }

        backgroundObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationWillResignActive,
            object: nil, queue: nil
        ) { [weak self] notification in
            guard let `self` = self, self.isTracking else { return }
            self.timer?.invalidate()
            self.timer = nil
            self.referenceTime = Date()
        }
        activeObserver = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil, queue: nil
        ) { [weak self] notification in
            guard let `self` = self, self.isTracking else { return }
            self.start()
        }
    }

    deinit {
        timer?.invalidate()
        _ = [backgroundObserver as Any, activeObserver as Any].flatMap(NotificationCenter.default.removeObserver)
    }

    func start() {
        isTracking = true
        referenceTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.referenceTime = Date()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        referenceTime = nil
        isTracking = false
    }
}
