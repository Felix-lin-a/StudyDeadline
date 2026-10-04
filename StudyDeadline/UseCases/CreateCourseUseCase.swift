//
//  CreateCourseUseCase.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import Foundation

/// Errors a student may encounter when creating a course.
enum CreateCourseUseCaseError: LocalizedError {
    case missingName
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .missingName:
            return "Please enter a course name before saving."

        case .saveFailed:
            return "Your course could not be saved. Please try again."
        }
    }
}

/// Creates a course that can organise the student's assessment deadlines.
///
/// A course must have a non-blank name.
/// The course code may be omitted.
struct CreateCourseUseCase {

    private let repository: DeadlineRepository

    init(repository: DeadlineRepository) {
        self.repository = repository
    }

    /// Validates the entered details and saves a new course.
    func execute(
        name: String,
        code: String? = nil
    ) throws -> Course {

        let cleanedName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedName.isEmpty else {
            throw CreateCourseUseCaseError.missingName
        }

        let cleanedCode = (code ?? "").trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let course = Course(
            id: UUID(),
            name: cleanedName,
            code: cleanedCode.isEmpty ? nil : cleanedCode
        )

        do {
            try repository.saveCourse(course)
        } catch {
            throw CreateCourseUseCaseError.saveFailed
        }

        return course
    }
}
