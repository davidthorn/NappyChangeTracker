//
//  NappyChangeTrackerApp.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

@main
internal struct NappyChangeTrackerApp: App {
    internal let serviceContainer: ServiceContainerProtocol

    internal init() {
        self.serviceContainer = AppServiceContainer(nappyChangeService: InMemoryNappyChangeService())
    }

    internal var body: some Scene {
        WindowGroup {
            ContentView(serviceContainer: serviceContainer)
        }
    }
}
