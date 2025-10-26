//
//  LocationRepository.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//
import Foundation
import Combine

protocol LocationRepository {
    func fetchLocations() -> AnyPublisher<[Location], Error>
}

