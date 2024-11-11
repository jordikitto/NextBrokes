//
//  Change.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 11/11/2024.
//

import Foundation
import Testing
import Combine

/// Waits for published value to change a certain number of times.
/// - Parameters:
///   - publisher: Publisher whose value should change as a result of `action` being run.
///   - expectedChangeCount: Expected amount of times the publisher should change.
///   - timeout: How long to wait for the publisher to change, in seconds.
///   - action: Action that should cause the publisher to change.
/// - Throws: If `action` throws.
func change<P: Publisher>(
    of publisher: P,
    expectedChangeCount: Int,
    timeout: Double = 1,
    sourceLocation: SourceLocation = #_sourceLocation,
    when action: @escaping () async throws -> Void
) async throws where P.Failure == Never {
    try await confirmation(expectedCount: expectedChangeCount) { confirm in
        try await withThrowingTaskGroup(of: ChangeResult.self) { group in
            // Setup timeout task
            group.addTask {
                do {
                    try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                    return .timeout
                } catch {
                    // Above will only throw CancellationError
                    return .unimportant
                }
            }
            // Setup task to monitor for expected changes
            group.addTask {
                var changeCount = 0
                for await _ in publisher.dropFirst().values {
                    confirm()
                    changeCount += 1
                    guard changeCount == expectedChangeCount else { continue }
                    return .success
                }
                // Should not reach here
                return .unimportant
            }
            // Setup task to run action that causes change
            group.addTask {
                try await action()
                return .unimportant
            }
            
            // Monitor results from tasks completion
            for try await result in group {
                switch result {
                case .success:
                    // Cancel all tasks, specifically the timeout task
                    group.cancelAll()
                case .timeout:
                    Issue.record(
                        "Timed out waiting for publisher to change.",
                        sourceLocation: sourceLocation
                    )
                    throw ChangeError.timedOut
                default: continue
                }
            }
        }
    }
}

/// Represents a result from a task when waiting for publisher to change
private enum ChangeResult {
    /// Change successfully occurred as expected.
    case success
    /// Change did not occur as expected in required amount of time.
    case timeout
    /// Result that isn't important to the final result.
    case unimportant
}

private enum ChangeError: Error {
    case timedOut
}
