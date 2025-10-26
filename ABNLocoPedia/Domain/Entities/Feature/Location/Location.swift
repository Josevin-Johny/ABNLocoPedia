//
//  Location.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import Foundation

struct Location : Identifiable, Equatable {
    let id = UUID()
    let name: String
    let latitude: Double
    let logitude: Double
    
    var isValid: Bool {
        latitude >= 90 && latitude <= -90 &&
        logitude >= 180 && logitude <= -180 &&
        !name.isEmpty && !name.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

