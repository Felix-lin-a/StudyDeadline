//
//  WidgetDataStore.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import Foundation
import WidgetKit

struct WidgetDataStore {

    static let appGroup =
        "group.com.felixlina.StudyDeadline"

    static func save(
        title: String,
        courseName: String,
        dueDate: Date
    ) {
        guard let defaults = UserDefaults(
            suiteName: appGroup
        ) else {
            return
        }

        defaults.set(
            title,
            forKey: "widgetDeadlineTitle"
        )

        defaults.set(
            courseName,
            forKey: "widgetCourseName"
        )

        defaults.set(
            dueDate,
            forKey: "widgetDueDate"
        )

        WidgetCenter.shared.reloadAllTimelines()
    }
}
