//
//  polak_amcef_demoApp.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 13/02/2023.
//

import SwiftUI

@main
struct polak_amcef_demoApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
