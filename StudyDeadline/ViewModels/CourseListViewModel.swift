//
//  CourseListViewModel.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import Foundation
import Observation

/// Manages course entry, the course list, and user-facing feedback.
@MainActor
@Observable
final class CourseListViewModel {

    var nameInput = ""
    var codeInput = ""

    private(set) var courses: [Course] = []
    private(set) var saveErrorMessage = ""
    private(set) var loadErrorMessage = ""
    private(set) var statusMessage = ""

    private let repository: DeadlineRepository
    private let createCourseUseCase: CreateCourseUseCase

    init(repository: DeadlineRepository) {
        self.repository = repository
        self.createCourseUseCase = CreateCourseUseCase(
            repository: repository
        )
    }

    /// Reads the stored courses without changing them.
    func loadCourses() {
        do {
            courses = try repository.fetchCourses()
            loadErrorMessage = ""
        } catch {
            loadErrorMessage =
                "Your courses could not be loaded. Tap Retry to try again."
        }
    }

    /// Saves a course after the use case validates the entered details.
    func createCourse() {
        saveErrorMessage = ""
        statusMessage = ""

        do {
            let course = try createCourseUseCase.execute(
                name: nameInput,
                code: codeInput
            )

            nameInput = ""
            codeInput = ""
            statusMessage = "Course saved: \(course.name)"

            loadCourses()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }
}
