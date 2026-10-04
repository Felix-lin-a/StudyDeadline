//
//  ContentView.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 2/10/2026.
//

import SwiftUI

struct ContentView: View {

    @State private var courseViewModel: CourseListViewModel

    init(repository: DeadlineRepository) {
        _courseViewModel = State(
            initialValue: CourseListViewModel(
                repository: repository
            )
        )
    }

    var body: some View {
        TabView {
            NavigationStack {
                CoursesView(viewModel: courseViewModel)
            }
            .tabItem {
                Label("Courses", systemImage: "books.vertical")
            }
        }
    }
}
