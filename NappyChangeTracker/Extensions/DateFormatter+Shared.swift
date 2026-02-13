//
//  DateFormatter+Shared.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal extension DateFormatter {
    static let sharedDateTimeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
