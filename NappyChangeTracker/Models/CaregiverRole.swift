//
//  CaregiverRole.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

/// The caregiver role associated with a nappy change.
public enum CaregiverRole: String, CaseIterable, Codable, Hashable, Sendable {
    /// The baby's mother.
    case mother

    /// The baby's father.
    case father

    /// A caregiver other than mother or father.
    case caregiver

    /// User-facing title for display.
    public var title: String {
        switch self {
        case .mother:
            return "Mother"
        case .father:
            return "Father"
        case .caregiver:
            return "Caregiver"
        }
    }
}
