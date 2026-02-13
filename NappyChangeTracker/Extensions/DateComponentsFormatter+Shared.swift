//
//  DateComponentsFormatter+Shared.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal extension DateComponentsFormatter {
    static let sharedHMSFormatter: DateComponentsFormatter = {
        let formatter: DateComponentsFormatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        formatter.maximumUnitCount = 2
        return formatter
    }()
}
