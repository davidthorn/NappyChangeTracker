//
//  NappyChangeDraft.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

/// Editable nappy change values used by forms before persistence.
public struct NappyChangeDraft: Codable, Hashable, Sendable {
    /// Date and time when the nappy was changed.
    public var changedAt: Date

    /// Selected nappy size.
    public var size: Int

    /// The role of the caregiver who made the change.
    public var caregiverRole: CaregiverRole

    /// Notes about the nappy condition.
    public var notes: String

    /// Creates a draft.
    public init(changedAt: Date, size: Int, caregiverRole: CaregiverRole, notes: String) {
        self.changedAt = changedAt
        self.size = size
        self.caregiverRole = caregiverRole
        self.notes = notes
    }

    /// Default draft for new entries.
    public static var `default`: NappyChangeDraft {
        NappyChangeDraft(changedAt: Date(), size: 0, caregiverRole: .caregiver, notes: "")
    }

    /// Initializes a draft from a persisted change.
    public init(change: NappyChange) {
        self.changedAt = change.changedAt
        self.size = change.size
        self.caregiverRole = change.caregiverRole
        self.notes = change.notes
    }
}
