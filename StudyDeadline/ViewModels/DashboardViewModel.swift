//
//  DashboardViewModel.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {

    private(set) var upcomingDeadlines: [Deadline] = []
    private(set) var errorMessage = ""

    private let repository: DeadlineRepository

    init(repository: DeadlineRepository) {
        self.repository = repository
    }

    /// Loads incomplete deadlines due within the next seven days.
    func loadUpcomingDeadlines() {
        let startDate = Date()

        guard let endDate = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: startDate
        ) else {
            errorMessage = "The upcoming date range could not be created."
            return
        }

        do {
            upcomingDeadlines = try repository.fetchUpcomingDeadlines(
                from: startDate,
                to: endDate
            )

            errorMessage = ""

            if let nextDeadline = upcomingDeadlines.first,
               let course = try repository.fetchCourse(
                   id: nextDeadline.courseID
               ) {

                WidgetDataStore.save(
                    title: nextDeadline.title,
                    courseName: course.name,
                    dueDate: nextDeadline.dueDate
                )
            }
        } catch {
            errorMessage =
                "Upcoming deadlines could not be loaded. Please try again."
        }
    }
}
