//
//  DateTrigger.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import Combine

/// Protocol to trigger an event at a specific date.
public protocol DateTriggerable {
    var triggerFired: AnyPublisher<Void, Never> { get }
    func schedule(_ date: Date)
}
 
/// Class to trigger an event at a specific date.
public class DateTrigger: DateTriggerable {
    private var timer: Timer?
    private var publisher: PassthroughSubject<Void, Never> = .init()
    
    public var triggerFired: AnyPublisher<Void, Never> { publisher.eraseToAnyPublisher() }
    
    public init() {}
    
    /// Schedules the given `date` to trigger ``triggerFired``.
    ///
    /// - Warning: If a date is already scheduled, it will be invalidated.
    /// - Parameter date: Date to fire the trigger at.
    public func schedule(_ date: Date) {
        // Invalidate previous timer
        timer?.invalidate()
        timer = nil
        
        // Setup new timer
        timer = Timer(fire: date, interval: 0, repeats: false) { [weak self] timer in
            self?.publisher.send()
            timer.invalidate()
            self?.timer = nil
        }
        
        // Schedule new timer
        guard let timer else { return }
        RunLoop.main.add(timer, forMode: .common)
    }
}
