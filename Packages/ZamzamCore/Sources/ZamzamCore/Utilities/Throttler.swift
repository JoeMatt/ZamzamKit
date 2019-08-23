//
//  Throttle.swift
//  https://github.com/soffes/RateLimit
//
//  Created by Basem Emara on 2018-10-07.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation

/// A throttler that will ignore work items until the time limit for the preceding call is over.
///
///     let limiter = Throttler(limit: 5)
///     var value = 0
///
///     limiter.execute {
///         value += 1
///     }
///
///     limiter.execute {
///         value += 1
///     }
///
///     limiter.execute {
///         value += 1
///     }
///
///     sleep(5)
///
///     limiter.execute {
///         value += 1
///     }
///
///     // value == 2
public final class Throttler {
    
    // MARK: - Properties
    
    private let limit: TimeInterval
    private var lastExecutedAt: Date?
    
    private let syncQueue = DispatchQueue(label: "\(DispatchQueue.labelPrefix).Throttler", attributes: [])
    
    /// Initialize a new throttler with given time interval.
    ///
    /// - Parameter limit: The number of seconds for throttle work items.
    public init(limit: TimeInterval) {
        self.limit = limit
    }
    
    /// Submits a work item and ensures it is not called until the delay is completed.
    ///
    /// - Parameter block: The work item to be invoked on the throttler.
    @discardableResult public func execute(_ block: () -> Void) -> Bool {
        let executed = syncQueue.sync { () -> Bool in
            let now = Date()
            
            // Lookup last executed
            let timeInterval = now.timeIntervalSince(lastExecutedAt ?? .distantPast)
            
            // If the time since last execution is greater than the limit, execute
            if timeInterval > limit {
                // Record execution
                lastExecutedAt = now
                
                // Execute
                return true
            }
            
            return false
        }
        
        if executed {
            block()
        }
        
        return executed
    }
    
    /// Cancels all work items to allow future work items to be executed with the specified delayed.
    public func reset() {
        syncQueue.sync {
            lastExecutedAt = nil
        }
    }
}
