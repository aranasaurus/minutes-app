//
//  Tracker.swift
//  Minutes
//
//  Created by Ryan Arana on 10/30/16.
//  Copyright © 2016 Aranasaurus. All rights reserved.
//

import Foundation

class Tracker {
    typealias DurationUpdateBlockType = (_ newValue: TimeInterval, _ oldValue: TimeInterval) -> Void
    var durationUpdateBlock: DurationUpdateBlockType?

    var duration: TimeInterval = 0 {
        didSet {
            durationUpdateBlock?(duration, oldValue)
        }
    }

    private(set) var referenceTime: Date?
    private var timer: Timer?

    init(updateBlock: DurationUpdateBlockType?) {
        self.durationUpdateBlock = updateBlock
    }

    deinit {
        timer?.invalidate()
    }

    func start() {
        referenceTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] timer in
            self.duration.add(timer.timeInterval)
            self.referenceTime = Date()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        guard let referenceTime = referenceTime else { return }
        duration.add(abs(referenceTime.timeIntervalSinceNow))
    }
}
