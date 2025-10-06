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
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                IndicatorsView(vm: IndicatorsViewModel())
            } else {
                LoginView()
            }
        }
    }
}
