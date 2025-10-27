//
//  LocationTests.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import XCTest

@testable import ABNLocoPedia

final class LocationTests: XCTestCase {
    
    //MARK: - Validation Test
    
    /// correct Location details
    func testValidation() {
        let location = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        XCTAssertTrue(location.isValid, "Location is valid")
    }
    
    /// Latitude higher than 90
    func testInvalidLatitude() {
        let location = Location(name: "Amsterdam", latitude: 92.12345, longitude: 4.9041)
        XCTAssertFalse(location.isValid, "Location is invalid")
    }
    
    /// Given: Latitude below -90
    func testInvalidLatitudeTooLow() {
        let location = Location(name: "Invalid", latitude: -91.0, longitude: 4.9041)
        XCTAssertFalse(location.isValid, "Location is invalid")
    }
    
    /// Given: Longitude above 180
    func testInvalidLongitudeTooHigh() {
        let location = Location(name: "Invalid", latitude: 52.3676, longitude: 181.0
        )
        // Then: Should be invalid
        XCTAssertFalse(location.isValid, "Location is invalid")
    }
    
    /// Given: Longitude below -180
    func testInvalidLongitudeTooLow() {
        let location = Location(name: "Invalid", latitude: 52.3676, longitude: -181.0
        )
        XCTAssertFalse(location.isValid, "Location is invalid")
    }
    
    // MARK: - Equatable Tests
    
    func testEqualityWithSameValues() {
        // Given: Two locations with same data
        let location1 = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        let location2 = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        
        // Then: Should be equal
        XCTAssertEqual(location1, location2, "Locations are same")
    }
    
    func testInequalityWithDifferentNames() {
        // Given: Locations with different names
        let location1 = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        let location2 = Location(name: "Rotterdam", latitude: 52.3676, longitude: 4.9041)
        
        // Then: Should not be equal
        XCTAssertNotEqual(location1, location2, "Locations are not same")
    }
    
    func testInequalityWithDifferentCoordinates() {
        // Given: Locations with different coordinates
        let location1 = Location(name: "Amsterdam", latitude: 52.3676, longitude: 4.9041)
        let location2 = Location(name: "Amsterdam", latitude: 51.9225, longitude: 4.4792)
        
        // Then: Should not be equal
        XCTAssertNotEqual(location1, location2, "Locations are not same")
    }
}

