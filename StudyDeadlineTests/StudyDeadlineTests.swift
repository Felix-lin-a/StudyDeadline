//
//  StudyDeadlineTests.swift
//  StudyDeadlineTests
//
//  Created by Tianqi Li's Macbook pro on 2/10/2026.
//

import XCTest
@testable import StudyDeadline

final class StudyDeadlineTests: XCTestCase {

    func testCreateCourse() throws {
        let repository = MockDeadlineRepository()
        let useCase = CreateCourseUseCase(
            repository: repository
        )

        let course = try useCase.execute(
            name: "Software Testing",
            code: "32547"
        )

        XCTAssertEqual(course.name, "Software Testing")
        XCTAssertEqual(course.code, "32547")
        XCTAssertEqual(repository.courses.count, 1)
        XCTAssertEqual(
            repository.courses.first?.id,
            course.id
        )
    }

    func testCreateCourseMissingNameError() throws {
        let repository = MockDeadlineRepository()
        let useCase = CreateCourseUseCase(
            repository: repository
        )

        XCTAssertThrowsError(
            try useCase.execute(
                name: "   ",
                code: "32547"
            )
        ) { error in
            XCTAssertEqual(
                error as? CreateCourseUseCaseError,
                .missingName
            )
        }

        XCTAssertEqual(repository.courses.count, 0)
    }
    
    func testCreateDeadline() throws {
        let repository = MockDeadlineRepository()

        let course = Course(
            id: UUID(),
            name: "Software Testing",
            code: "32547"
        )

        repository.courses.append(course)

        let useCase = CreateDeadlineUseCase(
            repository: repository
        )

        let dueDate = Date().addingTimeInterval(86400)

        let deadline = try useCase.execute(
            courseID: course.id,
            title: "Assignment 3",
            dueDate: dueDate,
            notes: "Finish report"
        )

        XCTAssertEqual(deadline.title, "Assignment 3")
        XCTAssertEqual(deadline.courseID, course.id)
        XCTAssertFalse(deadline.isCompleted)
        XCTAssertEqual(repository.deadlines.count, 1)
    }

    func testCreateDeadlineMissingTitleError() throws {
        let repository = MockDeadlineRepository()

        let course = Course(
            id: UUID(),
            name: "Software Testing",
            code: "32547"
        )

        repository.courses.append(course)

        let useCase = CreateDeadlineUseCase(
            repository: repository
        )

        XCTAssertThrowsError(
            try useCase.execute(
                courseID: course.id,
                title: "   ",
                dueDate: Date()
            )
        ) { error in
            XCTAssertEqual(
                error as? CreateDeadlineUseCaseError,
                .missingTitle
            )
        }

        XCTAssertEqual(repository.deadlines.count, 0)
    }
    
    func testUpdateDeadlineStatus() throws {
        let repository = MockDeadlineRepository()

        let courseID = UUID()

        let deadline = Deadline(
            id: UUID(),
            courseID: courseID,
            title: "Assignment 3",
            dueDate: Date(),
            isCompleted: false,
            notes: nil,
            sourceURL: nil
        )

        repository.deadlines.append(deadline)

        let useCase = UpdateDeadlineStatusUseCase(
            repository: repository
        )

        let updatedDeadline = try useCase.execute(
            deadlineID: deadline.id,
            isCompleted: true
        )

        XCTAssertTrue(updatedDeadline.isCompleted)
        XCTAssertTrue(repository.deadlines[0].isCompleted)
    }
    
    func testCreateCourseSaveFailure() throws {
        let repository = MockDeadlineRepository()

        repository.shouldFailSavingCourse = true

        let useCase = CreateCourseUseCase(
            repository: repository
        )

        XCTAssertThrowsError(
            try useCase.execute(
                name: "Software Testing",
                code: "32547"
            )
        ) { error in
            XCTAssertEqual(
                error as? CreateCourseUseCaseError,
                .saveFailed
            )
        }

        XCTAssertEqual(repository.courses.count, 0)
    }
}
