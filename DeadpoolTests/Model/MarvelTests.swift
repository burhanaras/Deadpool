//
//  MarvelTests.swift
//  DeadpoolTests
//
//  Created by Burhan Aras on 7/7/24.
//

import XCTest

final class MarvelTests: XCTestCase {
    
    func testFromDTOConversion() {
        // GIVEN a MarvelDTO instance
        let dto = MarvelDTO(id: 1, name: "Iron Man", description: "Genius billionaire playboy philanthropist", thumbnail: ThumbnailDTO(path: "/path/to/image", ext: "jpg"))
        
        // WHEN converting to Marvel
        let marvel = Marvel.fromDTO(dto: dto)
        
        // THEN verify the properties are correctly mapped
        XCTAssertEqual(marvel.id, "1")
        XCTAssertEqual(marvel.title, "Iron Man")
        XCTAssertEqual(marvel.description, "Genius billionaire playboy philanthropist")
        XCTAssertEqual(marvel.image.absoluteString, "/path/to/image.jpg")
    }
    
    func testFromDTOConversionWithEmptyStringURL() {
        // GIVEN a MarvelDTO instance with empty string thumbnail URL
        let dto = MarvelDTO(id: 1, name: "Iron Man", description: "Genius billionaire playboy philanthropist", thumbnail: ThumbnailDTO(path: "", ext: ""))
        
        // WHEN converting to Marvel
        let marvel = Marvel.fromDTO(dto: dto)
        
        // THEN verify the properties are correctly mapped
        XCTAssertEqual(marvel.id, "1")
        XCTAssertEqual(marvel.title, "Iron Man")
        XCTAssertEqual(marvel.description, "Genius billionaire playboy philanthropist")
        XCTAssertEqual(marvel.image.absoluteString, ".")
    }
}
