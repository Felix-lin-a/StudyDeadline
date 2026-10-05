//
//  CoursesView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import SwiftUI

/// Displays saved courses and lets the student open or add courses.
struct CoursesView: View {

    @Bindable var viewModel: CourseListViewModel

    let repository: DeadlineRepository

    var body: some View {
        List {
            if !viewModel.loadErrorMessage.isEmpty {
                Section {
                    Text(viewModel.loadErrorMessage)
                        .foregroundStyle(.red)

                    Button("Retry") {
                        viewModel.loadCourses()
                    }
                }
            }

            Section("Your Courses") {
                if viewModel.courses.isEmpty &&
                    viewModel.loadErrorMessage.isEmpty {
                    Text("No courses yet.")
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.courses) { course in
                    NavigationLink {
                        CourseDetailView(
                            viewModel: CourseDetailViewModel(
                                course: course,
                                repository: repository
                            )
                        )
                    } label: {
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
        }
        .navigationTitle("Courses")
        .toolbar {
            ToolbarItem(
                placement: .topBarTrailing
            ) {
                NavigationLink {
                    AddCourseView(
                        viewModel: viewModel
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            viewModel.loadCourses()
        }
    }
}
