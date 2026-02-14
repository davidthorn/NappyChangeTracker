//
//  DashboardScene.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

struct DashboardScene: View {
    let serviceContainer: ServiceContainerProtocol

    init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    var body: some View {
        NavigationStack {
            DashboardView(serviceContainer: serviceContainer)
                .navigationDestination(for: NappyChangeEditorMode.self) { mode in
                    NappyChangeEditorView(serviceContainer: serviceContainer, mode: mode)
                }
        }
    }
}

#if DEBUG
#Preview {
    let container: AppServiceContainer = AppServiceContainer(nappyChangeService: InMemoryNappyChangeService())
    DashboardScene(serviceContainer: container)
}
#endif
