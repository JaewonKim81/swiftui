//
//  TaskManagementCoreDataApp.swift
//  TaskManagementCoreData
//
//  Created by 김재원 on 2022/01/23.
//

import SwiftUI

@main
struct TaskManagementCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
