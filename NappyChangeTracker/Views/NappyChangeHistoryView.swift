//
//  NappyChangeHistoryView.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

internal struct NappyChangeHistoryView: View {
    @StateObject internal var viewModel: NappyChangeHistoryViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm: NappyChangeHistoryViewModel = NappyChangeHistoryViewModel(service: serviceContainer.nappyChangeService)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        List {
            if viewModel.changes.isEmpty {
                Text("No nappy changes available.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.changes) { change in
                    NavigationLink(value: NappyChangeEditorMode.edit(change.id)) {
                        NappyChangeRowView(change: change)
                    }
                }
            }
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: NappyChangeEditorMode.create) {
                    Image(systemName: "plus")
                }
            }
        }
        .task {
            viewModel.startObservingIfNeeded()
        }
    }
}

#if DEBUG
#Preview {
    let container: AppServiceContainer = AppServiceContainer(nappyChangeService: InMemoryNappyChangeService())
    NavigationStack {
        NappyChangeHistoryView(serviceContainer: container)
    }
}
#endif
