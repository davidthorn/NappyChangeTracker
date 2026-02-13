//
//  DashboardViewModel.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class DashboardViewModel: ObservableObject {
    @Published internal private(set) var changes: [NappyChange]

    internal let service: any NappyChangeServiceProtocol
    internal var observationTask: Task<Void, Never>?

    internal init(service: any NappyChangeServiceProtocol) {
        self.service = service
        self.changes = []
    }

    deinit {
        observationTask?.cancel()
    }

    internal var latestChange: NappyChange? {
        changes.first
    }

    internal var totalChanges: Int {
        changes.count
    }

    internal var averageIntervalDescription: String {
        guard changes.count > 1 else {
            return "Need at least 2 changes"
        }

        var intervals: [TimeInterval] = []
        for index in 0..<(changes.count - 1) {
            let current: Date = changes[index].changedAt
            let next: Date = changes[index + 1].changedAt
            intervals.append(abs(current.timeIntervalSince(next)))
        }

        let average: TimeInterval = intervals.reduce(0, +) / Double(intervals.count)
        let formatted: DateComponentsFormatter = DateComponentsFormatter.sharedHMSFormatter
        return formatted.string(from: average) ?? "Unavailable"
    }

    internal func startObservingIfNeeded() {
        guard observationTask == nil else {
            return
        }

        observationTask = Task { [service] in
            let stream: AsyncStream<[NappyChange]> = await service.stream()
            for await values in stream {
                if Task.isCancelled {
                    return
                }
                await MainActor.run {
                    self.changes = values
                }
            }
        }
    }
}
