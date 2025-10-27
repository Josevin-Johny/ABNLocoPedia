//
//  FetchLocationsUseCase.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//
import Foundation
import Combine

protocol FetchLocationsUseCaseProtocol {
    func execute() -> AnyPublisher<[Location], Error>
}

class FetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    
    private let repository: LocationRepository
    
    init(repository: LocationRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[Location], Error> {
        repository.fetchLocations()
            .map { locations in
                print("Debug: Fetched \(locations.count) locations from API")
                locations.forEach { print("  - \($0.name): \($0.latitude), \($0.longitude)") }
                // Business rule: Filter out invalid locations
                let validLocations = locations.filter { $0.isValid }
                print("Debug: \(validLocations.count) valid locations after filtering")
                
                return validLocations
            }
            .eraseToAnyPublisher()
    }
}
