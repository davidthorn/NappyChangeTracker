//
//  NappyChange.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

/// A persisted nappy change record.
public struct NappyChange: Identifiable, Codable, Hashable, Sendable {
    /// Unique identifier for this change entry.
    public let id: UUID

    /// Date and time when the nappy was changed.
    public var changedAt: Date

    /// Selected nappy size.
    public var size: Int

    /// The role of the caregiver who made the change.
    public var caregiverRole: CaregiverRole

    /// Notes about the prior nappy state or related details.
    public var notes: String

    /// Creation timestamp.
    public let createdAt: Date

    /// Last update timestamp.
    public var updatedAt: Date

    /// Creates a nappy change.
    public nonisolated init(
        id: UUID,
        changedAt: Date,
        size: Int,
        caregiverRole: CaregiverRole,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.changedAt = changedAt
        self.size = size
        self.caregiverRole = caregiverRole
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
