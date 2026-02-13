//
//  NappyChangeEditorMode.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

/// Navigation mode for the nappy change editor.
public enum NappyChangeEditorMode: Hashable, Sendable {
    /// Create a new change.
    case create

    /// Edit an existing change by identifier.
    case edit(UUID)

    /// Indicates if this mode edits persisted data.
    public var isEditing: Bool {
        switch self {
        case .create:
            return false
        case .edit:
            return true
        }
    }

    /// Title used by the editor screen.
    public var title: String {
        switch self {
        case .create:
            return "New Nappy Change"
        case .edit:
            return "Edit Nappy Change"
        }
    }
}
