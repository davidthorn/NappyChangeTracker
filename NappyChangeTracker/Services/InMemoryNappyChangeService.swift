//
//  InMemoryNappyChangeService.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal actor InMemoryNappyChangeService: NappyChangeServiceProtocol {
    internal var changes: [NappyChange]
    internal var continuations: [UUID: AsyncStream<[NappyChange]>.Continuation]

    internal init(seedChanges: [NappyChange] = []) {
        self.changes = seedChanges.sorted(by: { $0.changedAt > $1.changedAt })
        self.continuations = [:]
    }

    internal func stream() -> AsyncStream<[NappyChange]> {
        let token: UUID = UUID()
        let bufferingPolicy: AsyncStream<[NappyChange]>.Continuation.BufferingPolicy = .bufferingNewest(1)
        let pair: (stream: AsyncStream<[NappyChange]>, continuation: AsyncStream<[NappyChange]>.Continuation) = AsyncStream.makeStream(of: [NappyChange].self, bufferingPolicy: bufferingPolicy)
        continuations[token] = pair.continuation
        pair.continuation.yield(changes)
        pair.continuation.onTermination = { [weak self] _ in
            Task {
                await self?.removeContinuation(for: token)
            }
        }
        return pair.stream
    }

    internal func fetchAll() async -> [NappyChange] {
        changes
    }

    internal func fetch(id: UUID) async -> NappyChange? {
        changes.first(where: { $0.id == id })
    }

    internal func save(draft: NappyChangeDraft, id: UUID?) async -> NappyChange {
        let now: Date = Date()

        if let id {
            if let index: Int = changes.firstIndex(where: { $0.id == id }) {
                var existing: NappyChange = changes[index]
                existing.changedAt = draft.changedAt
                existing.size = draft.size
                existing.caregiverRole = draft.caregiverRole
                existing.notes = draft.notes
                existing.updatedAt = now
                changes[index] = existing
                sortAndPublish()
                return existing
            }
        }

        let newChange: NappyChange = NappyChange(
            id: UUID(),
            changedAt: draft.changedAt,
            size: draft.size,
            caregiverRole: draft.caregiverRole,
            notes: draft.notes,
            createdAt: now,
            updatedAt: now
        )
        changes.append(newChange)
        sortAndPublish()
        return newChange
    }

    internal func delete(id: UUID) async {
        changes.removeAll(where: { $0.id == id })
        sortAndPublish()
    }

    internal func removeContinuation(for token: UUID) {
        continuations[token] = nil
    }

    internal func sortAndPublish() {
        changes.sort(by: { $0.changedAt > $1.changedAt })
        let snapshot: [NappyChange] = changes
        for continuation in continuations.values {
            continuation.yield(snapshot)
        }
    }
}
