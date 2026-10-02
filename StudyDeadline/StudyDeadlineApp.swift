//
//  StudyDeadlineApp.swift
//  StudyDeadline
//
//  Created by Tianqi Li's Macbook pro on 2/10/2026.
//

import SwiftUI
import CoreData

@main
struct StudyDeadlineApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
