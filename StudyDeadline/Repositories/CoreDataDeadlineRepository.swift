//
//  CoreDataDeadlineRepository.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import Foundation
import CoreData

/// Errors encountered while storing or reading courses and deadlines.
enum DeadlineRepositoryError: Error {
    case invalidCourseData
    case invalidDeadlineData
    case courseNotFound
    case invalidDateRange
}

/// Stores and retrieves StudyDeadline data using Core Data.
///
/// Supply a dedicated context so a failed save can be rolled back
/// without discarding unrelated edits made elsewhere in the app.
final class CoreDataDeadlineRepository: DeadlineRepository {

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Courses

    /// Returns all courses sorted by name.
    func fetchCourses() throws -> [Course] {
        return try context.performAndWait {
            let request = NSFetchRequest<CourseEntity>(
                entityName: "CourseEntity"
            )
            request.sortDescriptors = [
                NSSortDescriptor(key: "name", ascending: true)
            ]

            let entities = try context.fetch(request)
            var courses: [Course] = []

            for entity in entities {
                let course = try makeCourse(from: entity)
                courses.append(course)
            }
            return courses
        }
    }

    /// Returns a course, or nil when its identifier is not found.
    func fetchCourse(id: UUID) throws -> Course? {
        return try context.performAndWait {
            guard let entity = try findCourseEntity(id: id) else {
                return nil
            }
            return try makeCourse(from: entity)
        }
    }

    /// Inserts a course or updates the course with the same identifier.
    func saveCourse(_ course: Course) throws {
        try context.performAndWait {
            let existingEntity = try findCourseEntity(id: course.id)
            let entity = existingEntity ?? CourseEntity(context: context)

            entity.id = course.id
            entity.name = course.name
            entity.code = course.code

            do {
                try context.save()
            } catch {
                context.rollback()
                throw error
            }
        }
    }

    // MARK: - Deadlines

    /// Returns one course's deadlines, ordered by due date.
    func fetchDeadlines(courseID: UUID) throws -> [Deadline] {
        return try context.performAndWait {
            let request = NSFetchRequest<DeadlineEntity>(
                entityName: "DeadlineEntity"
            )
            request.predicate = NSPredicate(
                format: "course.id == %@",
                courseID as NSUUID
            )
            request.sortDescriptors = [
                NSSortDescriptor(key: "dueDate", ascending: true)
            ]

            let entities = try context.fetch(request)
            var deadlines: [Deadline] = []

            for entity in entities {
                let deadline = try makeDeadline(from: entity)
                deadlines.append(deadline)
            }
            return deadlines
        }
    }

    /// Returns a deadline, or nil when its identifier is not found.
    func fetchDeadline(id: UUID) throws -> Deadline? {
        return try context.performAndWait {
            guard let entity = try findDeadlineEntity(id: id) else {
                return nil
            }
            return try makeDeadline(from: entity)
        }
    }

    /// Saves a deadline only when its course exists in the database.
    func saveDeadline(_ deadline: Deadline) throws {
        try context.performAndWait {
            guard let courseEntity = try findCourseEntity(
                id: deadline.courseID
            ) else {
                throw DeadlineRepositoryError.courseNotFound
            }

            let existingEntity = try findDeadlineEntity(id: deadline.id)
            let entity = existingEntity ?? DeadlineEntity(context: context)

            entity.id = deadline.id
            entity.title = deadline.title
            entity.dueDate = deadline.dueDate
            entity.isCompleted = deadline.isCompleted
            entity.notes = deadline.notes
            entity.sourceURL = deadline.sourceURL
            entity.course = courseEntity

            do {
                try context.save()
            } catch {
                context.rollback()
                throw error
            }
        }
    }

    /// Returns incomplete deadlines within a valid time range.
    ///
    /// Includes startDate, excludes endDate, and sorts by due date.
    func fetchUpcomingDeadlines(
        from startDate: Date,
        to endDate: Date
    ) throws -> [Deadline] {
        guard startDate < endDate else {
            throw DeadlineRepositoryError.invalidDateRange
        }

        return try context.performAndWait {
            let request = NSFetchRequest<DeadlineEntity>(
                entityName: "DeadlineEntity"
            )
            request.predicate = NSPredicate(
                format: "isCompleted == NO AND dueDate >= %@ AND dueDate < %@",
                startDate as NSDate,
                endDate as NSDate
            )
            request.sortDescriptors = [
                NSSortDescriptor(key: "dueDate", ascending: true)
            ]

            let entities = try context.fetch(request)
            var deadlines: [Deadline] = []

            for entity in entities {
                let deadline = try makeDeadline(from: entity)
                deadlines.append(deadline)
            }
            return deadlines
        }
    }

    // MARK: - Helpers used on the context's queue

    private func findCourseEntity(id: UUID) throws -> CourseEntity? {
        let request = NSFetchRequest<CourseEntity>(
            entityName: "CourseEntity"
        )
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func findDeadlineEntity(id: UUID) throws -> DeadlineEntity? {
        let request = NSFetchRequest<DeadlineEntity>(
            entityName: "DeadlineEntity"
        )
        request.predicate = NSPredicate(
            format: "id == %@",
            id as NSUUID
        )
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    /// Converts a stored course into the app's domain model.
    private func makeCourse(from entity: CourseEntity) throws -> Course {
        guard let id = entity.id,
              let name = entity.name else {
            throw DeadlineRepositoryError.invalidCourseData
        }

        return Course(
            id: id,
            name: name,
            code: entity.code
        )
    }

    /// Reads the course identifier through the Core Data relationship.
    private func makeDeadline(from entity: DeadlineEntity) throws -> Deadline {
        guard let id = entity.id,
              let title = entity.title,
              let dueDate = entity.dueDate,
              let courseID = entity.course?.id else {
            throw DeadlineRepositoryError.invalidDeadlineData
        }

        return Deadline(
            id: id,
            courseID: courseID,
            title: title,
            dueDate: dueDate,
            isCompleted: entity.isCompleted,
            notes: entity.notes,
            sourceURL: entity.sourceURL
        )
    }
}
