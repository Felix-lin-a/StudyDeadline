//
//  StudyDeadlineWidget.swift
//  StudyDeadlineWidget
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import WidgetKit
import SwiftUI

struct DeadlineEntry: TimelineEntry {
    let date: Date
    let title: String
    let dueDate: Date
    let courseName: String
}

struct Provider: TimelineProvider {

    private let appGroup =
        "group.com.felixlina.StudyDeadline"

    func placeholder(in context: Context) -> DeadlineEntry {
        DeadlineEntry(
            date: Date(),
            title: "Upcoming Deadline",
            dueDate: Date(),
            courseName: "Course"
        )
    }

    func getSnapshot(
        in context: Context,
        completion: @escaping (DeadlineEntry) -> Void
    ) {
        completion(loadEntry())
    }

    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<DeadlineEntry>) -> Void
    ) {
        let entry = loadEntry()

        let timeline = Timeline(
            entries: [entry],
            policy: .never
        )

        completion(timeline)
    }

    private func loadEntry() -> DeadlineEntry {
        let defaults = UserDefaults(
            suiteName: appGroup
        )

        let title =
            defaults?.string(
                forKey: "widgetDeadlineTitle"
            ) ?? "No upcoming deadline"

        let courseName =
            defaults?.string(
                forKey: "widgetCourseName"
            ) ?? ""

        let dueDate =
            defaults?.object(
                forKey: "widgetDueDate"
            ) as? Date ?? Date()

        return DeadlineEntry(
            date: Date(),
            title: title,
            dueDate: dueDate,
            courseName: courseName
        )
    }
}

struct StudyDeadlineWidgetEntryView: View {

    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Upcoming Deadline")
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(entry.title)
                .font(.headline)

            if !entry.courseName.isEmpty {
                Text(entry.courseName)
                    .font(.caption)
            }

            Text(
                entry.dueDate,
                format: .dateTime
                    .day()
                    .month()
                    .hour()
                    .minute()
            )
            .font(.caption)
            .foregroundStyle(.secondary)

            Spacer()
        }
        .containerBackground(
            .fill.tertiary,
            for: .widget
        )
    }
}

struct StudyDeadlineWidget: Widget {

    let kind: String = "StudyDeadlineWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            StudyDeadlineWidgetEntryView(
                entry: entry
            )
        }
        .configurationDisplayName(
            "Upcoming Deadline"
        )
        .description(
            "Shows your next upcoming assessment deadline."
        )
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}  
