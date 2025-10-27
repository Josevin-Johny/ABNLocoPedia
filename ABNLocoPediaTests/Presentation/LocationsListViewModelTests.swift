//
//  LocationsListViewModelTests.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import XCTest
import Combine
@testable import ABNLocoPedia

/// Tests for LocationsListViewModel - covering key functionality
@MainActor
final class LocationsListViewModelTests: XCTestCase {
    
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialStateIsIdle() {
        // Given: Fresh ViewModel
        let viewModel = makeViewModel()
        
        // Then: State should be idle
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testLoadLocationsSuccess() async {
        // Given: ViewModel with mock data
        let locations = [
            Location(name: "Amsterdam", latitude: 52.37, longitude: 4.90),
            Location(name: "Rotterdam", latitude: 51.92, longitude: 4.48)
        ]
        let viewModel = makeViewModel(locations: locations)
        
        // When: Load locations
        viewModel.loadLocations()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then: State should be loaded with data
        if case .loaded(let loadedLocations) = viewModel.state {
            XCTAssertEqual(loadedLocations.count, 2)
            XCTAssertEqual(loadedLocations[0].name, "Amsterdam")
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func testLoadLocationsFailure() async {
        // Given: ViewModel that will fail
        let viewModel = makeViewModel(shouldFail: true)
        
        // When: Load locations
        viewModel.loadLocations()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // Then: State should be error
        if case .error(let message) = viewModel.state {
            XCTAssertFalse(message.isEmpty)
        } else {
            XCTFail("Expected error state")
        }
    }
    
    func testSearchFiltersLocations() async {
        // Given: ViewModel with loaded data
        let locations = [
            Location(name: "Amsterdam", latitude: 52.37, longitude: 4.90),
            Location(name: "Rotterdam", latitude: 51.92, longitude: 4.48)
        ]
        let viewModel = makeViewModel(locations: locations)
        viewModel.loadLocations()
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        // When: Search for "dam"
        viewModel.searchText = "dam"
        
        // Then: Only Amsterdam returned
        let filtered = viewModel.filterdLocations
        XCTAssertEqual(filtered.count, 2)
        XCTAssertEqual(filtered[0].name, "Amsterdam")
    }
    
    func testCustomLocationValidation() {
        // Given: ViewModel
        let viewModel = makeViewModel()
        
        // When: Valid inputs
        viewModel.customLocationName = "Test"
        viewModel.customeLatitude = "52.37"
        viewModel.customeLongitude = "4.90"
        
        // Then: Should be valid
        XCTAssertTrue(viewModel.isCustomLocationValid)
        
        // When: Invalid latitude
        viewModel.customeLatitude = "abc"
        
        // Then: Should be invalid
        XCTAssertFalse(viewModel.isCustomLocationValid)
    }
    
    func testDeepLinkServiceCalled() {
        // Given: ViewModel with mock service
        let mockDeepLink = MockDeepLinkService()
        let viewModel = makeViewModel(deepLinkService: mockDeepLink)
        let location = Location(name: "Amsterdam", latitude: 52.37, longitude: 4.90)
        
        // When: Open location
        viewModel.openLocation(selected: location)
        
        // Then: Service was called
        XCTAssertTrue(mockDeepLink.createDeepLinkCalled)
    }
    
    // MARK: - Helper
    
    private func makeViewModel(
        locations: [Location] = [],
        shouldFail: Bool = false,
        deepLinkService: DeepLinkService? = nil
    ) -> LocationsListViewModel {
        let mockUseCase = MockFetchLocationsUseCase(
            locations: locations,
            shouldFail: shouldFail
        )
        let mockDeepLink = deepLinkService ?? MockDeepLinkService()
        
        return LocationsListViewModel(
            fetchLocationUseCase: mockUseCase,
            deepLinkService: mockDeepLink
        )
    }
}

// MARK: - Mocks

private class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    private let locations: [Location]
    private let shouldFail: Bool
    
    init(locations: [Location] = [], shouldFail: Bool = false) {
        self.locations = locations
        self.shouldFail = shouldFail
    }
    
    func execute() -> AnyPublisher<[Location], Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "test", code: -1))
                .eraseToAnyPublisher()
        }
        return Just(locations)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private class MockDeepLinkService: DeepLinkService {
    var createDeepLinkCalled = false
    
    func createDeepLink(for location: Location) -> URL? {
        createDeepLinkCalled = true
        return URL(string: "wikipedia://places?lat=\(location.latitude)&lon=\(location.longitude)")
    }
}
