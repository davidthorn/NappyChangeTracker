//
//  HistoryScene.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

internal struct HistoryScene: View {
    internal let serviceContainer: ServiceContainerProtocol

    internal init(serviceContainer: ServiceContainerProtocol) {
        self.serviceContainer = serviceContainer
    }

    internal var body: some View {
        NavigationStack {
            NappyChangeHistoryView(serviceContainer: serviceContainer)
                .navigationDestination(for: NappyChangeEditorMode.self) { mode in
                    NappyChangeEditorView(serviceContainer: serviceContainer, mode: mode)
                }
        }
    }
}

#if DEBUG
#Preview {
    let container: AppServiceContainer = AppServiceContainer(nappyChangeService: InMemoryNappyChangeService())
    HistoryScene(serviceContainer: container)
}
#endif
