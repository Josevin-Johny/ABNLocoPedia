//
//  DeepLinkServiceTests.swift
//  ABNLocoPedia
//
//  Created by Josevin Johny on 27/10/2025.
//

import XCTest
@testable import ABNLocoPedia

/// Tests for WikipediaDeepLinkService
final class DeepLinkServiceTests: XCTestCase {
    
    private var service: WIkiPediaAppDeepLink!
    
    override func setUp() {
        super.setUp()
        service = WIkiPediaAppDeepLink()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    // MARK: - Deep Link Creation Tests
    
    func testCreateDeepLinkReturnsValidURL() {
        // Given: A location
        let location = Location(
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041
        )
        
        // When: Create deep link
        let url = service.createDeepLink(for: location)
        
        // Then: Valid URL returned
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.scheme, "abnamro-test")
        XCTAssertEqual(url?.host, "places")
    }
    
    func testDeepLinkContainsCorrectCoordinates() {
        // Given: A location
        let location = Location(
            name: "Amsterdam",
            latitude: 52.3676,
            longitude: 4.9041
        )
        
        // When: Create deep link
        guard let url = service.createDeepLink(for: location),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            XCTFail("Failed to create URL")
            return
        }
        
        // Then: Contains correct coordinates
        let latQuery = components.queryItems?.first(where: { $0.name == "lat" })
        let lonQuery = components.queryItems?.first(where: { $0.name == "lon" })
        
        XCTAssertEqual(latQuery?.value, "52.3676")
        XCTAssertEqual(lonQuery?.value, "4.9041")
    }
    
    func testDeepLinkWithNegativeCoordinates() {
        // Given: Location with negative coordinates
        let location = Location(
            name: "Mumbai",
            latitude: -34.6037,
            longitude: -58.3816
        )
        
        // When: Create deep link
        guard let url = service.createDeepLink(for: location),
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            XCTFail("Failed to create URL")
            return
        }
        
        // Then: Contains negative values
        let latQuery = components.queryItems?.first(where: { $0.name == "lat" })
        let lonQuery = components.queryItems?.first(where: { $0.name == "lon" })
        
        XCTAssertEqual(latQuery?.value, "-34.6037")
        XCTAssertEqual(lonQuery?.value, "-58.3816")
    }
}
