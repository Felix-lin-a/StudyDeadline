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
        List {
            Section("Course") {
                Text(viewModel.course.name)
                    .font(.headline)

                if let code = viewModel.course.code {
                    Text("Course code: \(code)")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Deadlines") {
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                }

                if viewModel.deadlines.isEmpty &&
                    viewModel.errorMessage.isEmpty {
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
                                Image(
                                    systemName: "checkmark.circle.fill"
                                )
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
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                NavigationLink {
                    AddDeadlineView(
                        viewModel: viewModel
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadDeadlines()
        }
    }
}
