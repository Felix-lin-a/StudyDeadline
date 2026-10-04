//
//  UpdateDeadlineStatusUseCase.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 4/10/2026.
//

import Foundation

enum UpdateDeadlineStatusUseCaseError: LocalizedError {
    case deadlineNotFound
    case loadFailed
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .deadlineNotFound:
            return "The selected deadline no longer exists."

        case .loadFailed:
            return "The deadline could not be loaded. Please try again."

        case .saveFailed:
            return "The deadline status could not be updated. Please try again."
        }
    }
}

struct UpdateDeadlineStatusUseCase {

    private let repository: DeadlineRepository

    init(repository: DeadlineRepository) {
        self.repository = repository
    }

    func execute(
        deadlineID: UUID,
        isCompleted: Bool
    ) throws -> Deadline {

        let existingDeadline: Deadline?

        do {
            existingDeadline = try repository.fetchDeadline(
                id: deadlineID
            )
        } catch {
            throw UpdateDeadlineStatusUseCaseError.loadFailed
        }

        guard let existingDeadline else {
            throw UpdateDeadlineStatusUseCaseError.deadlineNotFound
        }

        let updatedDeadline = Deadline(
            id: existingDeadline.id,
            courseID: existingDeadline.courseID,
            title: existingDeadline.title,
            dueDate: existingDeadline.dueDate,
            isCompleted: isCompleted,
            notes: existingDeadline.notes,
            sourceURL: existingDeadline.sourceURL
        )

        do {
            try repository.saveDeadline(updatedDeadline)
        } catch {
            throw UpdateDeadlineStatusUseCaseError.saveFailed
        }

        return updatedDeadline
    }
}
