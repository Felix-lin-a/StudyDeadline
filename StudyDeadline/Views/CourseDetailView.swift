//
//  CourseDetailView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 4/10/2026.
//

import SwiftUI

struct CourseDetailView: View {

    @Bindable var viewModel: CourseDetailViewModel

    var body: some View {
        Form {
            Section("Course") {
                Text(viewModel.course.name)
                    .font(.headline)

                if let code = viewModel.course.code {
                    Text(code)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Add Deadline") {
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

                Button("Save Deadline") {
                    viewModel.createDeadline()
                }

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                if !viewModel.statusMessage.isEmpty {
                    Text(viewModel.statusMessage)
                        .font(.caption)
                }
            }

            Section("Deadlines") {
                if viewModel.deadlines.isEmpty {
                    Text("No deadlines yet.")
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.deadlines) { deadline in
                    VStack(alignment: .leading, spacing: 8) {

                        HStack {
                            Text(deadline.title)
                                .font(.headline)

                            Spacer()

                            if deadline.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }

                        Text(
                            deadline.dueDate,
                            format: .dateTime
                                .day()
                                .month()
                                .year()
                                .hour()
                                .minute()
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        if let notes = deadline.notes {
                            Text(notes)
                                .font(.caption)
                        }

                        Button(
                            deadline.isCompleted
                                ? "Mark Incomplete"
                                : "Mark Complete"
                        ) {
                            viewModel.updateDeadlineStatus(
                                deadline: deadline,
                                isCompleted: !deadline.isCompleted
                            )
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.course.name)
        .onAppear {
            viewModel.loadDeadlines()
        }
    }
}
