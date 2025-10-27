//
//  FetchLocationsUseCaseTests.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import XCTest
import Combine

@testable import ABNLocoPedia

final class FetchLocationsUseCaseTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables = nil
    }
    
    func testExecuteReturnOnlyValidLocations() {
        let mockRepository =  MockLocationRepository (
            locations: [
                Location(name: "Valid1", latitude: 52.37, longitude: 4.90),
                Location(name: "Invalid", latitude: 200.0, longitude: 4.90), // Invalid lat
                Location(name: "Valid2", latitude: 51.92, longitude: 4.48),
                Location(name: "Invalid2", latitude: 52.37, longitude: 300.0) // Invalid long
            ]
        )
        
        let useCase = FetchLocationsUseCase(repository: mockRepository)
        // When: Execute use case
        let expectation = expectation(description: "Fetch Locations")
        var receivedLocations : [Location] = []
        
        useCase.execute()
            .sink (
                receiveCompletion: { _ in },
                receiveValue: { locations in
                    receivedLocations = locations
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        //Only Valid locations Returne
        XCTAssertEqual(receivedLocations.count, 2)
        XCTAssertEqual(receivedLocations[0].name, "Valid1")
        XCTAssertEqual(receivedLocations[1].name, "Valid2")
        
    }
    
    func testExecuteReturnsEmptyArrayWhenNoValidLocations() {
        // Given: Repository with only invalid locations
        let mockRepository = MockLocationRepository(
            locations: [
                Location(name: "Invalid1", latitude: 200.0, longitude: 4.90),
                Location(name: "Invalid2", latitude: 52.37, longitude: 300.0)
            ]
        )
        
        let useCase = FetchLocationsUseCase(repository: mockRepository)
        
        // When: Execute use case
        let expectation = expectation(description: "Fetch locations")
        var receivedLocations: [Location] = []
        
        useCase.execute()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { locations in
                    receivedLocations = locations
                    expectation.fulfill()
                }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Empty array returned
        XCTAssertTrue(receivedLocations.isEmpty)
    }
    
    func testExecuteForwardsRepositoryError() {
        // Given: Repository that returns error
        let mockRepository = MockLocationRepository(shouldFail: true)
        let useCase = FetchLocationsUseCase(repository: mockRepository)
        
        // When: Execute use case
        let expectation = expectation(description: "Fetch locations")
        var receivedError: Error?
        
        useCase.execute()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        receivedError = error
                        expectation.fulfill()
                    }
                },
                receiveValue: { _ in }
            )
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then: Error is forwarded
        XCTAssertNotNil(receivedError)
    }
}


// MARK: - Mock Repository
private class MockLocationRepository: LocationRepository {
    private let locations: [Location]
    private let shouldFail: Bool
    
    init(locations: [Location] = [], shouldFail: Bool = false) {
        self.locations = locations
        self.shouldFail = shouldFail
    }
    
    func fetchLocations() -> AnyPublisher<[Location], Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "test", code: -1))
                .eraseToAnyPublisher()
        }
        
        return Just(locations)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
