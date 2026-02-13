//
//  NappyChangeRowView.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

internal struct NappyChangeRowView: View {
    internal let change: NappyChange

    internal init(change: NappyChange) {
        self.change = change
    }

    internal var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(DateFormatter.sharedDateTimeFormatter.string(from: change.changedAt))
                .font(.headline)
            Text("Size \(change.size) • \(change.caregiverRole.title)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if !change.notes.isEmpty {
                Text(change.notes)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 2)
    }
}

#if DEBUG
#Preview {
    NappyChangeRowView(
        change: NappyChange(
            id: UUID(),
            changedAt: Date(),
            size: 4,
            caregiverRole: .caregiver,
            notes: "Slight rash observed.",
            createdAt: Date(),
            updatedAt: Date()
        )
    )
}
#endif
