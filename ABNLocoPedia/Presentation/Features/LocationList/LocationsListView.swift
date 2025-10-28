//
//  LocationsListView.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import SwiftUI
import Combine


/// Main view displaying list of locations fetched from ABN AMRO Test API
///
/// Features:
/// - Fetches and displays locations on launch
/// - Search functionality to filter locations -  **Additional, not part of Assignment**
/// - Tap location to open in Wikipedia app via deep link
/// - Add custom location with manual coordinates
/// - Handles loading, error, and Idel screens
///
/// Architecture: MVVM with Combine reactive states

struct LocationsListView : View {
    
    // MARK: - Properties
    
    /// ViewModel managing business logic and state
    @StateObject private var viewModel: LocationsListViewModel
    
    /// custom location input sheet
    @State private var showingCustomLocationSheet = false
    
    
    // MARK: - Initialization
        
    /// Creates LocationsListView with injected ViewModel
    /// - Parameter viewModel: ViewModel containing business logic
    init(viewModel: LocationsListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                stateContent
            }
            .navigationTitle("Locations")
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search Locations"
            )
            .accessibilityHint("Use search to filter locations by name")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingCustomLocationSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .accessibilityLabel("Add custom location")
                            .accessibilityHint("Opens form to enter custom coordinates")
                    }
                }
            }
            .sheet(isPresented: $showingCustomLocationSheet) {
                CustomLocationSheetView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadLocations()
            }
        }
    }
    
    // MARK: - State Content
        
    /// Returns appropriate view based on current state
    @ViewBuilder
    private var stateContent: some View {
        switch viewModel.state {
        case .idle:
            idleView
        case .loading:
            loadingView
        case .loaded:
            locationsListView
        case .error(let message):
            errorView(message: message)
        }
    }
    
    /// Initial state before loading data
    private var idleView: some View {
        VStack(spacing: 16) {
            Image(systemName: "map")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
            
            Text ("Ready to go")
                .font(.title2)
            
            Text ("Tap to load locations")
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Ready to explore")
        .accessibilityHint("Locations will load automatically")
    }
    
    /// Shown while fetching locations from API
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text ("Loading loacations...")
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Loading locations")
        .accessibilityValue("Please wait")
    }
        
    /// Displays list of locations with search filtering
    private var locationsListView: some View {
        List {
            ForEach(viewModel.filterdLocations) { location in
                LocationRowView(location: location)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.openLocation(selected: location)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(accessibilityLabel(location))
                    .accessibilityHint("Double tap to open in Wikipedia app")
                    .accessibilityAddTraits(.isButton)
            }
        }
        .listStyle(.plain)
        .accessibilityLabel("Locations list")
        .overlay {
            if viewModel.filterdLocations.isEmpty {
                emptySearchView
            }
        }
        
    }
    
    /// Shown when search returns no results
    private var emptySearchView: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No results found")
                .font(.title2)
            
            Text("Try a different search term")
                .foregroundColor(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("No results found for \(viewModel.searchText)")
    }
    
    /// Displays error message with retry button
    /// - Parameter message: Error description to show user
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
            
            Text(message)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Retry") {
                viewModel.loadLocations()
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Retry loading locations")
            .accessibilityHint("Double tap to try loading again")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error loading locations. \(message)")
        .accessibilityHint("Use retry button to try again")
    }
    
}

// MARK: - Preview

#Preview {
    // Mock dependencies for preview
    let mockUseCase = MockFetchLocationsUseCase()
    let mockDeepLink = WIkiPediaAppDeepLink()
    let viewModel = LocationsListViewModel(
        fetchLocationUseCase: mockUseCase,
        deepLinkService: mockDeepLink)
    
    LocationsListView(viewModel: viewModel)
}

// MARK: - Mock for Preview

/// Mock use case for SwiftUI previews
/// Returns hardcoded locations for testing UI

final class MockFetchLocationsUseCase: FetchLocationsUseCaseProtocol {
    func execute() -> AnyPublisher<[Location], Error> {
        let locations = [
            Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041),
            Location(name: "Rotterdam", latitude: 51.9225, longitude: 4.4791),
            Location(name: "Utrecht", latitude:  52.0907, longitude: 5.1214)
        ]
        
        return Just(locations)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}


