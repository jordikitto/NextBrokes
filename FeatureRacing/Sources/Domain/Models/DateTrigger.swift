//
//  DateTrigger.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 9/11/2024.
//

import Foundation
import Combine

public protocol DateTriggerable {
    var triggerFired: AnyPublisher<Void, Never> { get }
    func schedule(_ date: Date)
}
 
public class DateTrigger: DateTriggerable {
    private var timer: Timer?
    private var publisher: PassthroughSubject<Void, Never> = .init()
    
    public var triggerFired: AnyPublisher<Void, Never> { publisher.eraseToAnyPublisher() }
    
    public init() {}
    
    public func schedule(_ date: Date) {
        timer?.invalidate()
        timer = nil
        
        timer = Timer(fire: date, interval: 0, repeats: false) { [weak self] timer in
            self?.publisher.send()
            timer.invalidate()
            self?.timer = nil
        }
        
        guard let timer else { return }
        RunLoop.main.add(timer, forMode: .common)
    }
}
