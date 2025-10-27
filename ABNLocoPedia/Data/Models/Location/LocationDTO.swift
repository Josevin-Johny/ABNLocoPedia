//
//  LocationDTO.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import Foundation

struct LocationDTO : Decodable {
    let name: String?
    let lat: Double
    let long: Double
    
    func convertToDomain() -> Location {
        return Location(name: name ?? "Unknown Place", latitude: lat, logitude: long)
    }
}

struct LocationResponse : Decodable {
    let locations: [LocationDTO]
}
