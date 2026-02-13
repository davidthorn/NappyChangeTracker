//
//  NappyChangeEditorViewModel.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Combine
import Foundation

@MainActor
internal final class NappyChangeEditorViewModel: ObservableObject {
    @Published internal var draft: NappyChangeDraft

    internal let service: any NappyChangeServiceProtocol
    internal let mode: NappyChangeEditorMode
    internal var persistedID: UUID?
    internal var originalDraft: NappyChangeDraft?

    internal init(service: any NappyChangeServiceProtocol, mode: NappyChangeEditorMode) {
        self.service = service
        self.mode = mode
        self.draft = .default

        switch mode {
        case .create:
            self.persistedID = nil
            self.originalDraft = nil
        case .edit(let id):
            self.persistedID = id
            self.originalDraft = nil
        }
    }

    internal var sizeOptions: [Int] {
        Array(0...10)
    }

    internal var isPersisted: Bool {
        persistedID != nil
    }

    internal var hasChanges: Bool {
        switch mode {
        case .create:
            return draft != .default
        case .edit:
            guard let originalDraft else {
                return false
            }
            return draft != originalDraft
        }
    }

    internal func loadIfNeeded() async {
        guard case .edit(let id) = mode else {
            return
        }
        guard originalDraft == nil else {
            return
        }

        if let existing: NappyChange = await service.fetch(id: id) {
            let existingDraft: NappyChangeDraft = NappyChangeDraft(change: existing)
            draft = existingDraft
            originalDraft = existingDraft
            persistedID = existing.id
        }
    }

    internal func save() async {
        let saved: NappyChange = await service.save(draft: draft, id: persistedID)
        persistedID = saved.id
        let nextOriginal: NappyChangeDraft = NappyChangeDraft(change: saved)
        originalDraft = nextOriginal
        draft = nextOriginal
    }

    internal func delete() async {
        guard let persistedID else {
            return
        }
        await service.delete(id: persistedID)
    }

    internal func reset() {
        guard let originalDraft else {
            return
        }
        draft = originalDraft
    }
}
