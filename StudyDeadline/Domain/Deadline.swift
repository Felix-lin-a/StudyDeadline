//
//  Deadline.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import Foundation

/// Represents an assessment deadline belonging to a university course.
///
/// Stores the due date, completion status, and any supporting information
/// that helps the student understand and track the assessment.
struct Deadline: Identifiable {

    let id: UUID

    /// The identifier of the course this deadline belongs to.
    let courseID: UUID

    let title: String
    let dueDate: Date
    let isCompleted: Bool
    let notes: String?
    let sourceURL: String?
}
