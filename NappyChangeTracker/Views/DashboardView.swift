//
//  DashboardView.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

internal struct DashboardView: View {
    @StateObject internal var viewModel: DashboardViewModel

    internal init(serviceContainer: ServiceContainerProtocol) {
        let vm: DashboardViewModel = DashboardViewModel(service: serviceContainer.nappyChangeService)
        self._viewModel = StateObject(wrappedValue: vm)
    }

    internal var body: some View {
        List {
            Section("Last Change") {
                if let latest: NappyChange = viewModel.latestChange {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(DateFormatter.sharedDateTimeFormatter.string(from: latest.changedAt))
                            .font(.headline)
                        Text("Size \(latest.size) • \(latest.caregiverRole.title)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        if !latest.notes.isEmpty {
                            Text(latest.notes)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                } else {
                    Text("No nappy changes recorded yet.")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Overview") {
                LabeledContent("Total changes", value: "\(viewModel.totalChanges)")
                LabeledContent("Average interval", value: viewModel.averageIntervalDescription)
                Text("More statistics can be added here later.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Actions") {
                NavigationLink(value: NappyChangeEditorMode.create) {
                    Label("Record Nappy Change", systemImage: "plus.circle.fill")
                }
            }
        }
        .navigationTitle("Dashboard")
        .task {
            viewModel.startObservingIfNeeded()
        }
    }
}

#if DEBUG
#Preview {
    let container: AppServiceContainer = AppServiceContainer(nappyChangeService: InMemoryNappyChangeService())
    
    
    return NavigationStack {
        DashboardView(serviceContainer: container)
    }
}
#endif
