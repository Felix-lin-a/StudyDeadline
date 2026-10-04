//
//  Course.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 3/10/2026.
//

import Foundation

/// Represents a university course used to organise assessment deadlines.
///
/// A course has an identifier and a name.
/// The course code is optional.
struct Course: Identifiable {

    let id: UUID
    let name: String
    let code: String?
}
