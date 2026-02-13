//
//  NappyChangeEditorView.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import SwiftUI

internal struct NappyChangeEditorView: View {
    @Environment(\.dismiss) internal var dismiss
    @StateObject internal var viewModel: NappyChangeEditorViewModel
    @State internal var showDeleteConfirmation: Bool

    internal init(serviceContainer: ServiceContainerProtocol, mode: NappyChangeEditorMode) {
        let vm: NappyChangeEditorViewModel = NappyChangeEditorViewModel(service: serviceContainer.nappyChangeService, mode: mode)
        self._viewModel = StateObject(wrappedValue: vm)
        self._showDeleteConfirmation = State(initialValue: false)
    }

    internal var body: some View {
        Form {
            Section("Change Details") {
                DatePicker("Changed at", selection: $viewModel.draft.changedAt)

                Picker("Nappy size", selection: $viewModel.draft.size) {
                    ForEach(viewModel.sizeOptions, id: \.self) { size in
                        Text("Size \(size)")
                            .tag(size)
                    }
                }

                Picker("Caregiver", selection: $viewModel.draft.caregiverRole) {
                    ForEach(CaregiverRole.allCases, id: \.self) { role in
                        Text(role.title)
                            .tag(role)
                    }
                }
            }

            Section("Notes") {
                TextField(
                    "e.g. wet nappy, skin condition, anything to remember",
                    text: $viewModel.draft.notes,
                    axis: .vertical
                )
                .lineLimit(3...8)
            }

            if viewModel.hasChanges {
                Section("Actions") {
                    Button("Save") {
                        Task {
                            if Task.isCancelled {
                                return
                            }
                            await viewModel.save()
                            if Task.isCancelled {
                                return
                            }
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }

            if viewModel.isPersisted && viewModel.hasChanges {
                Section {
                    Button("Reset Changes", role: .cancel) {
                        viewModel.reset()
                    }
                }
            }

            if viewModel.isPersisted {
                Section {
                    Button("Delete", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
        }
        .navigationTitle(viewModel.mode.title)
        .alert("Are you sure you want to delete this?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task {
                    if Task.isCancelled {
                        return
                    }
                    await viewModel.delete()
                    if Task.isCancelled {
                        return
                    }
                    dismiss()
                }
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }
}

#if DEBUG
#Preview {
    let container: AppServiceContainer = AppServiceContainer(nappyChangeService: InMemoryNappyChangeService())
    NavigationStack {
        NappyChangeEditorView(serviceContainer: container, mode: .create)
    }
}
#endif
