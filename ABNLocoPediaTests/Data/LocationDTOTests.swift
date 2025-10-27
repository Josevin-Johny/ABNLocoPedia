//
//  LocationDTOTests.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import XCTest
@testable import ABNLocoPedia

/// Tests for LocationDTO data conversion
final class LocationDTOTests: XCTestCase {
    
    
    func testToDomainConvertsCorrectly() {
        // Given: DTO with data
        let dto = LocationDTO(
            name: "Amsterdam",
            lat: 52.3676,
            long: 4.9041
        )
        
        // When: Convert to domain
        let location = dto.convertToDomain()
        
        // Then: Values mapped correctly
        XCTAssertEqual(location.name, "Amsterdam")
        XCTAssertEqual(location.latitude, 52.3676, accuracy: 0.0001)
        XCTAssertEqual(location.longitude, 4.9041, accuracy: 0.0001)
    }
    
    func testToDomainWithMissingName() {
        // Given: DTO with nil name
        let dto = LocationDTO(
            name: nil,
            lat: 40.4380638,
            long: -3.7495758
        )
        
        // When: Convert to domain
        let location = dto.convertToDomain()
        
        // Then: Default name used
        XCTAssertEqual(location.name, "Unknown Place")
        XCTAssertEqual(location.latitude, 40.4380638, accuracy: 0.0001)
        XCTAssertEqual(location.longitude, -3.7495758, accuracy: 0.0001)
    }
    
    func testDecodingFromJSONWithoutName() throws {
        // Given: JSON without name field
        let json = """
        {
            "lat": 40.4380638,
            "long": -3.7495758
        }
        """.data(using: .utf8)!
        
        // When: Decode JSON
        let dto = try JSONDecoder().decode(LocationDTO.self, from: json)
        
        // Then: Name is nil
        XCTAssertNil(dto.name)
        XCTAssertEqual(dto.lat, 40.4380638, accuracy: 0.0001)
    }
    
}
