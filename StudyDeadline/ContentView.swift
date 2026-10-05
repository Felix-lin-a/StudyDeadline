//
//  ContentView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 2/10/2026.
//

import SwiftUI

struct ContentView: View {

    @State private var courseViewModel: CourseListViewModel
    @State private var dashboardViewModel: DashboardViewModel

    private let repository: DeadlineRepository

    init(repository: DeadlineRepository) {
        self.repository = repository

        _courseViewModel = State(
            initialValue: CourseListViewModel(
                repository: repository
            )
        )

        _dashboardViewModel = State(
            initialValue: DashboardViewModel(
                repository: repository
            )
        )
    }

    var body: some View {
        TabView {

            NavigationStack {
                DashboardView(
                    viewModel: dashboardViewModel
                )
            }
            .tabItem {
                Label(
                    "Dashboard",
                    systemImage: "calendar"
                )
            }

            NavigationStack {
                CoursesView(
                    viewModel: courseViewModel,
                    repository: repository
                )
            }
            .tabItem {
                Label(
                    "Courses",
                    systemImage: "books.vertical"
                )
            }
        }
    }
}
