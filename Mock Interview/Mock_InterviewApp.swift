//
//  Mock_InterviewApp.swift
//  Mock Interview
//
//  Created by Svetlana Yurkevich on 18/03/2024.
//

import SwiftUI

@main
struct Mock_InterviewApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
