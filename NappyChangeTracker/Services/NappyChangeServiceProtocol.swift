//
//  NappyChangeServiceProtocol.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal protocol NappyChangeServiceProtocol: Actor {
    func stream() -> AsyncStream<[NappyChange]>
    func fetchAll() async -> [NappyChange]
    func fetch(id: UUID) async -> NappyChange?
    func save(draft: NappyChangeDraft, id: UUID?) async -> NappyChange
    func delete(id: UUID) async
}
