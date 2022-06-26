//
//  IncomeExpenseAppApp.swift
//  IncomeExpenseApp
//
//  Created by Twinkle T on 2022-06-25.
//

import SwiftUI

@main
struct IncomeExpenseApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
