//
//  MyEconomicIndicatorsApp.swift
//  MyEconomicIndicators
//
//  Created by Daniel Nunez on 05-10-25.
//

import SwiftUI

@main
struct MyEconomicIndicatorsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
