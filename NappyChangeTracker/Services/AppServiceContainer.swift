//
//  AppServiceContainer.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal struct AppServiceContainer: ServiceContainerProtocol {
    internal let nappyChangeService: NappyChangeServiceProtocol

    internal init(nappyChangeService: NappyChangeServiceProtocol) {
        self.nappyChangeService = nappyChangeService
    }
}
