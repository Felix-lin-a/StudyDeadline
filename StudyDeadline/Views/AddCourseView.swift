//
//  AddCourseView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import SwiftUI

struct AddCourseView: View {

    @Bindable var viewModel: CourseListViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            Section("Course Details") {
                TextField(
                    "Course name",
                    text: $viewModel.nameInput
                )

                TextField(
                    "Course code (optional)",
                    text: $viewModel.codeInput
                )
            }

            Section {
                Button("Save Course") {
                    viewModel.createCourse()

                    if viewModel.saveErrorMessage.isEmpty {
                        dismiss()
                    }
                }
            }

            if !viewModel.saveErrorMessage.isEmpty {
                Section {
                    Text(viewModel.saveErrorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Add Course")
    }
}
