//
//  LocationDTO.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 26/10/2025.
//

import Foundation

struct LocationDTO : Decodable {
    let name: String
    let lat: Double
    let lon: Double
    
    func convertToDomain() -> Location {
        return Location(name: name, latitude: lat, logitude: lon)
    }
}

struct LocationResponse : Decodable {
    let locations: [LocationDTO]
}
