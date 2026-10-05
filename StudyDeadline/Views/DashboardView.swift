//
//  DashboardView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 5/10/2026.
//

import SwiftUI

struct DashboardView: View {

    @Bindable var viewModel: DashboardViewModel

    var body: some View {
        List {
            Section("Next 7 Days") {

                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)

                    Button("Retry") {
                        viewModel.loadUpcomingDeadlines()
                    }
                }

                if viewModel.upcomingDeadlines.isEmpty &&
                    viewModel.errorMessage.isEmpty {
                    Text("No upcoming deadlines.")
                        .foregroundStyle(.secondary)
                }

                ForEach(viewModel.upcomingDeadlines) { deadline in
                    VStack(alignment: .leading, spacing: 6) {

                        Text(deadline.title)
                            .font(.headline)

                        Text(
                            deadline.dueDate,
                            format: .dateTime
                                .day()
                                .month()
                                .year()
                                .hour()
                                .minute()
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        if let notes = deadline.notes {
                            Text(notes)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
        .onAppear {
            viewModel.loadUpcomingDeadlines()
        }
    }
}
