//
//  LocationRepositoryImp.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//
import Foundation
import Combine


class LocationRepositoryImpl: LocationRepository {
    
    private let networkService: NetworkSerivceProtocol
    private let apiURL: URL
    
    init(
        networkService: NetworkSerivceProtocol,
        apiURL: URL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
    ) {
        self.networkService = networkService
        self.apiURL = apiURL
    }
    
    func fetchLocations() -> AnyPublisher<[Location], any Error> {
        networkService.fetch(from: apiURL)
            .map { (response: LocationResponse) in
                response.locations.map { $0.convertToDomain()}
            }
            .eraseToAnyPublisher()
    }
}
