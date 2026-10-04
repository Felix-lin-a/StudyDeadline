//
//  CoursesView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import SwiftUI

/// Lets a student create courses and view their saved courses.
struct CoursesView: View {

    @Bindable var viewModel: CourseListViewModel

    var body: some View {
        Form {
            Section("Add Course") {
                TextField(
                    "Course name",
                    text: $viewModel.nameInput
                )

                TextField(
                    "Course code (optional)",
                    text: $viewModel.codeInput
                )

                Button("Save Course") {
                    viewModel.createCourse()
                }

                if !viewModel.saveErrorMessage.isEmpty {
                    Text(viewModel.saveErrorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                if !viewModel.statusMessage.isEmpty {
                    Text(viewModel.statusMessage)
                        .font(.caption)
                }
            }

            Section("Your Courses") {
                if !viewModel.loadErrorMessage.isEmpty {
                    Text(viewModel.loadErrorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)

                    Button("Retry") {
                        viewModel.loadCourses()
                    }
                }

                if viewModel.courses.isEmpty &&
                    viewModel.loadErrorMessage.isEmpty {
                    Text("No courses yet. Add your first course above.")
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.courses) { course in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(course.name)
                            .font(.headline)

                        if let code = course.code {
                            Text("Course code: \(code)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Courses")
        .onAppear {
            viewModel.loadCourses()
        }
    }
}
