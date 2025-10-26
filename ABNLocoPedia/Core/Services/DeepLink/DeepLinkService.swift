//
//  DeepLinkService.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import Foundation

protocol DeepLinkService {
    func createDeepLink(for location: Location) -> URL?
}

class WIkiPediaAppDeepLink : DeepLinkService {
    
    func createDeepLink(for location: Location) -> URL? {
        guard location.isValid else { return nil }
        var components = URLComponents()
        components.scheme = WikiPediaApp.scheme
        components.host = WikiPediaApp.host
        
        // Querry Params for wikkipedia application
        components.queryItems = [
            URLQueryItem(name: WikiPediaApp.QuerryParam.lattitude, value: String(location.latitude)),
            URLQueryItem(name: WikiPediaApp.QuerryParam.longitude, value: String(location.logitude))
        ]
        return components.url
    }
}

//Demonstrating Scalability
class GoogleMapsDeepLink : DeepLinkService {
    func createDeepLink(for location: Location) -> URL? {
        return nil
    }
}

