//
//  ComicsTests.swift
//  DeadpoolTests
//
//  Created by Burhan Aras on 7/7/24.
//

import XCTest

final class ComicsTests: XCTestCase {
    
    func testFromDTOConversion() {
        // GIVEN a ComicDTO instance
        let dto = ComicDTO(id: 1, title: "Avengers", thumbnail: ThumbnailDTO(path: "/path/to/image", ext: "jpg"))
        
        // WHEN converting to Comics
        let comics = Comics.fromDTO(dto: dto)
        
        // THEN verify the properties are correctly mapped
        XCTAssertEqual(comics.id, 1)
        XCTAssertEqual(comics.title, "Avengers")
        XCTAssertEqual(comics.image.absoluteString, "/path/to/image.jpg")
    }
    
    func testFromDTOConversionWithEmptyStringURL() {
        // GIVEN a ComicDTO instance with empty string thumbnail URL
        let dto = ComicDTO(id: 1, title: "Avengers", thumbnail: ThumbnailDTO(path: "", ext: ""))
        
        // WHEN converting to Comics
        let comics = Comics.fromDTO(dto: dto)
        
        // THEN verify the properties are correctly mapped
        XCTAssertEqual(comics.id, 1)
        XCTAssertEqual(comics.title, "Avengers")
        XCTAssertEqual(comics.image.absoluteString, ".")
    }
}
