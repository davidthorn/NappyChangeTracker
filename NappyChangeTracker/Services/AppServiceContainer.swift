//
//  AppServiceContainer.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal struct AppServiceContainer: ServiceContainerProtocol {
    internal let nappyChangeService: any NappyChangeServiceProtocol

    internal init(nappyChangeService: any NappyChangeServiceProtocol) {
        self.nappyChangeService = nappyChangeService
    }
}
