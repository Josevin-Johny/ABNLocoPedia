//
//  LocationViewStae.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import Foundation

// MARK: - LocationViewState

/// usage:
/// - Clear UI logic (one view per state)
/// - Testable
enum LocationViewState: Equatable {
    case idle
    case loading
    case loaded([Location])
    case error(String)
    
    static func == (lhs: LocationViewState, rhs: LocationViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.loaded(let l1), .loaded(let l2)): return l1 == l2
        case (.error(let e1), .error(let e2)): return e1 == e2
        default: return false
        }
    }
}
