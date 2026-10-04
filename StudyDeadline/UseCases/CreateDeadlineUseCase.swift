//
//  CreateDeadlineUseCase.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 4/10/2026.
//

import Foundation

/// Errors a student may encounter when adding an assessment deadline.
enum CreateDeadlineUseCaseError: LocalizedError {

    case missingTitle
    case courseNotFound
    case courseLoadFailed
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .missingTitle:
            return "Please enter an assessment title before saving."

        case .courseNotFound:
            return "The selected course no longer exists. Return to Courses and select or create a course."

        case .courseLoadFailed:
            return "The selected course could not be loaded. Return to Courses and try again."

        case .saveFailed:
            return "Your assessment deadline could not be saved. Please try again."
        }
    }
}

/// Creates an assessment deadline belonging to an existing course.
///
/// The assessment title must not be blank.
/// A new deadline starts as incomplete.
/// Notes and a source link are optional.
struct CreateDeadlineUseCase {

    private let repository: DeadlineRepository

    init(repository: DeadlineRepository) {
        self.repository = repository
    }

    /// Validates the entered details and saves a new deadline.
    func execute(
        courseID: UUID,
        title: String,
        dueDate: Date,
        notes: String? = nil,
        sourceURL: String? = nil
    ) throws -> Deadline {

        let cleanedTitle = title.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedTitle.isEmpty else {
            throw CreateDeadlineUseCaseError.missingTitle
        }

        let selectedCourse: Course?

        do {
            selectedCourse = try repository.fetchCourse(
                id: courseID
            )
        } catch {
            throw CreateDeadlineUseCaseError.courseLoadFailed
        }

        guard selectedCourse != nil else {
            throw CreateDeadlineUseCaseError.courseNotFound
        }

        let cleanedNotes = (notes ?? "").trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let cleanedSourceURL = (sourceURL ?? "").trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        let deadline = Deadline(
            id: UUID(),
            courseID: courseID,
            title: cleanedTitle,
            dueDate: dueDate,
            isCompleted: false,
            notes: cleanedNotes.isEmpty ? nil : cleanedNotes,
            sourceURL: cleanedSourceURL.isEmpty ? nil : cleanedSourceURL
        )

        do {
            try repository.saveDeadline(deadline)
        } catch {
            throw CreateDeadlineUseCaseError.saveFailed
        }

        return deadline
    }
}
