//
//  DIContainer.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import Foundation


/// Dependecy Injection container, here we assembles all the dependency Injections
final class DIContainer {
    
    /// Creating singelton
    static let shared = DIContainer()
    
    private init() {}
    
    // MARK: - Services wuth Lazy initialzsers
    private lazy var networkSerivce: NetworkSerivceProtocol = {
        NetworkSerivce()
    }()
    
    private lazy var deepLinkService: DeepLinkService = {
        WIkiPediaAppDeepLink()
    }()
    
    // MARK: - Repositories
    
    private lazy var locationRepository: LocationRepository = {
        LocationRepositoryImpl(networkService: networkSerivce)
    }()
    
    // MARK: - Use Cases
    
    private lazy var fetchLocationsUseCase: FetchLocationsUseCaseProtocol = {
        FetchLocationsUseCase(repository: locationRepository)
    }()
    
    
    /// Create LocationsListViewModel with all dependencies
    func makeLocationsListViewModel() -> LocationsListViewModel {
        LocationsListViewModel(
            fetchLocationUseCase: fetchLocationsUseCase,
            deepLinkService: deepLinkService
        )
    }
    
    /// Create main LocationsListView
    func makeLocationsListView() -> LocationsListView {
        let viewModel = makeLocationsListViewModel()
        return LocationsListView(viewModel: viewModel)
    }
}
