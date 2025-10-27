//
//  ABNLocoPediaApp.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 25/10/2025.
//

import SwiftUI

@main
struct ABNLocoPediaApp: App {
    private let diContainer = DIContainer.shared
    var body: some Scene {
        WindowGroup {
            diContainer.makeLocationsListView()
        }
    }
}
