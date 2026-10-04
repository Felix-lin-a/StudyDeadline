//
//  DeadlineRepository.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import Foundation

/// Provides access to courses and their assessment deadlines.
///
/// The app uses a Core Data implementation.
/// Unit tests use a mock implementation of the same protocol.
protocol DeadlineRepository {

    /// Returns the student's courses.
    func fetchCourses() throws -> [Course]

    /// Returns a course, or nil when its identifier is not found.
    func fetchCourse(id: UUID) throws -> Course?

    /// Inserts a course, or updates the course with the same identifier.
    func saveCourse(_ course: Course) throws

    /// Returns the deadlines belonging to a particular course.
    func fetchDeadlines(courseID: UUID) throws -> [Deadline]

    /// Returns a deadline, or nil when its identifier is not found.
    func fetchDeadline(id: UUID) throws -> Deadline?

    /// Inserts a deadline, or updates the deadline with the same identifier.
    func saveDeadline(_ deadline: Deadline) throws

    /// Returns incomplete deadlines ordered by their due date.
    ///
    /// Includes startDate and excludes endDate.
    func fetchUpcomingDeadlines(
        from startDate: Date,
        to endDate: Date
    ) throws -> [Deadline]
}
