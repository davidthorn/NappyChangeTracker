//
//  NappyChangeHistoryViewModel.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class NappyChangeHistoryViewModel: ObservableObject {
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
