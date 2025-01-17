//
//  Pictora_AIApp.swift
//  Pictora AI
//
//  Created by Abdulbasit Ajaga on 17/01/2025.
//

import SwiftUI

@main
struct Pictora_AIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
