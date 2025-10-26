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
                locations.filter { $0.isValid }
                //locations.filter { $0.OnlyInEurope} demonstrationg change in the business rule
            }
            .eraseToAnyPublisher()
    }
}
