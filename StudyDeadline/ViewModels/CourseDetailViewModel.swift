//
//  CourseDetailViewModel.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 4/10/2026.
//

import Foundation
import Observation

/// Manages deadlines belonging to one course.
@MainActor
@Observable
final class CourseDetailViewModel {

    let course: Course

    var titleInput = ""
    var dueDateInput = Date()
    var notesInput = ""

    private(set) var deadlines: [Deadline] = []
    private(set) var errorMessage = ""
    private(set) var statusMessage = ""

    private let repository: DeadlineRepository
    private let createDeadlineUseCase: CreateDeadlineUseCase

    init(
        course: Course,
        repository: DeadlineRepository
    ) {
        self.course = course
        self.repository = repository
        self.createDeadlineUseCase = CreateDeadlineUseCase(
            repository: repository
        )
    }

    /// Loads all deadlines belonging to this course.
    func loadDeadlines() {
        do {
            deadlines = try repository.fetchDeadlines(
                courseID: course.id
            )
            errorMessage = ""
        } catch {
            errorMessage =
                "Your assessment deadlines could not be loaded. Please try again."
        }
    }

    /// Creates a deadline using the current form values.
    func createDeadline() {
        errorMessage = ""
        statusMessage = ""

        do {
            let deadline = try createDeadlineUseCase.execute(
                courseID: course.id,
                title: titleInput,
                dueDate: dueDateInput,
                notes: notesInput
            )

            titleInput = ""
            notesInput = ""
            statusMessage = "Deadline saved: \(deadline.title)"

            loadDeadlines()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
