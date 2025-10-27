//
//  LocationsListViewModel.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import Foundation
import Combine
import UIKit


/// ViewModel managing LocationsList presentation logic
///
/// Responsibilities:
/// - Fetch locations from use case
/// - Manage view state (idle, loading, loaded, error)
/// - Filter locations based on search text
/// - Handle custom location input and validation
/// - Create deep links and open Wikipedia app
///
/// Architecture: MVVM with Combine for reactive updates
/// @MainActor ensures all updates on main thread

class LocationsListViewModel: ObservableObject {
    
    @Published private(set) var state: LocationViewState = .idle
    @Published var searchText: String = ""
    @Published var customLocationName = ""
    @Published var customeLatitude = ""
    @Published var customeLongitude = ""
    
    private let fetchLocationUseCase: FetchLocationsUseCaseProtocol
    private let deepLinkService: DeepLinkService
    private var cancellables: Set<AnyCancellable> = []
    
    
    /// Creates ViewModel with injected dependencies
        /// - Parameters:
        ///   - fetchLocationsUseCase: Use case for location fetching
        ///   - deepLinkService: Service for creating deep links
    init(
        fetchLocationUseCase: FetchLocationsUseCaseProtocol,
        deepLinkService: DeepLinkService
    ) {
        self.fetchLocationUseCase = fetchLocationUseCase
        self.deepLinkService = deepLinkService
    }
    
    // MARK: - Public Methods
    
    /// Load locations from API
    func loadLocations() {
        state = .loading
        
        fetchLocationUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    print("Debug: Completion received: \(completion)")
                    if case .failure(let error) = completion {
                        print("Debug: Error: \(error)")
                        self?.state = .error(error.localizedDescription)
                    }
                },
                receiveValue: { [weak self] locations in
                    print("Debug: ViewModel received \(locations.count) locations")
                    print("Debug: About to set state to .loaded")
                    self?.state = .loaded(locations)
                    print("Debug: State is now: \(self?.state ?? .idle)")
                }
            )
            .store(in: &cancellables)
        
    }
    
    /// Filtered locations based on search text
    var filterdLocations: [Location] {
        print("Debug: filteredLocations called, current state: \(state)")
        guard case .loaded(let locations) = state else {
            print("Debug: State is NOT .loaded, it's: \(state)")
            return []
        }
        
        print("Debug: State IS .loaded with \(locations.count) locations")
        
        if searchText.isEmpty {
            print("debug: No search text, returning all \(locations.count) locations")
            return locations
        }
        
        let filteredLocations = locations.filter { location in
            location.name.localizedCaseInsensitiveContains(searchText)
        }
        
        print("Debug: After filtering: \(filteredLocations.count) locations")
        return filteredLocations
        
    }
    
    /// Open location in Wikipedia app using deep link
    func openLocation(selected location: Location) {
        guard let url = deepLinkService.createDeepLink(for: location) else {
            print("failed to create deep link for \(location.name)")
            return
        }
        UIApplication.shared.open(url)
    }
    
    /// Create and open custom location
    func openCustomLocation() {
        guard let customLocation = createCustomLocation() else {
            print("invalid custom locaton")
            return
        }
        openLocation(selected: customLocation)
        clearCustomLocationFields()
    }
    
    // MARK: - Private Methods
    
    /// Validate custom location inputs
    var isCustomLocationValid: Bool {
        guard !customLocationName.trimmingCharacters(in: .whitespaces).isEmpty,
              let lat = Double(customeLatitude),
              let lon = Double(customeLongitude) else {
            return false
        }
        
        return lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180
    }
    
    /// Create location from custom inputs
    private func createCustomLocation() -> Location? {
        guard let lat = Double(customeLatitude),
              let lon = Double(customeLongitude) else {
            return nil
        }
        
        let location = Location(
            name: customLocationName.trimmingCharacters(in: .whitespaces),
            latitude: lat,
            logitude: lon
        )
        return location.isValid ? location : nil
    }
    
    /// Clear custom location input fields
    private func clearCustomLocationFields() {
        customLocationName = ""
        customeLatitude = ""
        customeLongitude = ""
    }
}

