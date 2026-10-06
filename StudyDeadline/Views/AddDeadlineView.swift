//
//  AddDeadlineView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import SwiftUI

struct AddDeadlineView: View {

    @Bindable var viewModel: CourseDetailViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Assessment Details") {
                TextField(
                    "Assessment title",
                    text: $viewModel.titleInput
                )

                DatePicker(
                    "Due date",
                    selection: $viewModel.dueDateInput
                )

                TextField(
                    "Notes (optional)",
                    text: $viewModel.notesInput
                )
                
                TextField(
                    "Source URL (optional)",
                    text: $viewModel.sourceURLInput
                )
            }

            Section {
                Button("Save Deadline") {
                    viewModel.createDeadline()

                    if viewModel.errorMessage.isEmpty {
                        dismiss()
                    }
                }
            }

            if !viewModel.errorMessage.isEmpty {
                Section {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Add Deadline")
        .onAppear {
            viewModel.loadSharedURL()
        }
    }
    
}
