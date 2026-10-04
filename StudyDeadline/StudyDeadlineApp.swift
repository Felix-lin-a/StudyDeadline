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

    private let persistenceController: PersistenceController
    private let repository: DeadlineRepository

    init() {
        let persistence = PersistenceController.shared

        // A separate working context for the repository.
        let repositoryContext = NSManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType
        )

        // Use the same persistent store as the existing container.
        repositoryContext.persistentStoreCoordinator =
            persistence.container.persistentStoreCoordinator

        self.persistenceController = persistence

        self.repository = CoreDataDeadlineRepository(
            context: repositoryContext
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
    }
}
