//
//  MockDeadlineRepository.swift
//  StudyDeadlineTests
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import Foundation
@testable import StudyDeadline

final class MockDeadlineRepository: DeadlineRepository {

    var courses: [Course] = []
    var deadlines: [Deadline] = []

    var shouldFailFetchingCourses = false
    var shouldFailFetchingDeadlines = false
    var shouldFailSavingCourse = false
    var shouldFailSavingDeadline = false

    enum MockError: Error {
        case forcedFailure
    }

    func fetchCourses() throws -> [Course] {
        if shouldFailFetchingCourses {
            throw MockError.forcedFailure
        }

        return courses
    }

    func fetchCourse(id: UUID) throws -> Course? {
        if shouldFailFetchingCourses {
            throw MockError.forcedFailure
        }

        return courses.first {
            $0.id == id
        }
    }

    func saveCourse(_ course: Course) throws {
        if shouldFailSavingCourse {
            throw MockError.forcedFailure
        }

        if let index = courses.firstIndex(
            where: { $0.id == course.id }
        ) {
            courses[index] = course
        } else {
            courses.append(course)
        }
    }

    func fetchDeadlines(courseID: UUID) throws -> [Deadline] {
        if shouldFailFetchingDeadlines {
            throw MockError.forcedFailure
        }

        return deadlines.filter {
            $0.courseID == courseID
        }
    }

    func fetchDeadline(id: UUID) throws -> Deadline? {
        if shouldFailFetchingDeadlines {
            throw MockError.forcedFailure
        }

        return deadlines.first {
            $0.id == id
        }
    }

    func saveDeadline(_ deadline: Deadline) throws {
        if shouldFailSavingDeadline {
            throw MockError.forcedFailure
        }

        if let index = deadlines.firstIndex(
            where: { $0.id == deadline.id }
        ) {
            deadlines[index] = deadline
        } else {
            deadlines.append(deadline)
        }
    }

    func fetchUpcomingDeadlines(
        from startDate: Date,
        to endDate: Date
    ) throws -> [Deadline] {

        if shouldFailFetchingDeadlines {
            throw MockError.forcedFailure
        }

        return deadlines
            .filter {
                !$0.isCompleted &&
                $0.dueDate >= startDate &&
                $0.dueDate < endDate
            }
            .sorted {
                $0.dueDate < $1.dueDate
            }
    }
}
