//
//  DeadpoolUITests.swift
//  DeadpoolUITests
//
//  Created by Burhan Aras on 7/6/24.
//

import XCTest

final class DeadpoolUITests: XCTestCase {
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func test_shows_marvel_carousel_title() {
        let app = XCUIApplication()
        app.launch()
        // Mock successful data loading (implementation depends on your view model)
        let title = app.staticTexts["Marvel Characters"]
        XCTAssertTrue(title.exists)
    }
    
    func test_launches_successfully() {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
        XCTAssertTrue(app.exists)
        
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        let pageSize = 30
        let data = DummyDataGenerator.generateCharactersResponse(start: 0, number: pageSize)
        let title = data.data.results[0].name
        let description = data.data.results[0].description
        let expected = title + ", " + description
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        XCTAssert(elementsQuery.buttons[expected].exists)
    }
    
    
    func test_first_page_loads_successfully() {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
        XCTAssertTrue(app.exists)
        
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        (0..<29).forEach { _ in
            XCUIRemote.shared.press(.right)
        }
        
        let pageSize = 30
        let data = DummyDataGenerator.generateCharactersResponse(start: 0, number: pageSize)
        let item = data.data.results[29]
        let expected = item.name + ", " + item.description
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        XCTAssert(elementsQuery.buttons[expected].exists)
    }
    
    
    func test_paging_works_successfully() {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
        XCTAssertTrue(app.exists)
        
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        let pageSize = 30
        let pageCount = 2
        (0...(pageSize * pageCount)).forEach { _ in
            XCUIRemote.shared.press(.right)
        }
        
        let data = DummyDataGenerator.generateCharactersResponse(start: 30, number: pageSize)
        if let item = data.data.results.last {
            let expected = item.name + ", " + item.description
            let elementsQuery = XCUIApplication().scrollViews.otherElements
            XCTAssert(elementsQuery.buttons[expected].exists)
        } else {
            XCTFail("Response data is empty")
        }
    }
    
    
    func test_marvel_detail_loads_successfully() {
        let app = XCUIApplication()
        app.launchArguments.append("UITesting")
        app.launch()
        XCTAssertTrue(app.exists)
        
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        let pageSize = 30
        let data = DummyDataGenerator.generateCharactersResponse(start: 0, number: pageSize)
        let title = data.data.results[0].name
        let description = data.data.results[0].description
        let expected = title + ", " + description
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        XCTAssert(elementsQuery.buttons[expected].hasFocus)
        
        XCUIRemote.shared.press(.select)
        
        XCTAssert(elementsQuery.staticTexts[title].exists)
        
        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        XCUIRemote.shared.press(.left)
        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.right)
        XCUIRemote.shared.press(.up)
        XCUIRemote.shared.press(.up)
        XCUIRemote.shared.press(.down)
        XCTAssert(elementsQuery.buttons["Add To Favorites"].hasFocus)
        XCUIRemote.shared.press(.select)
    }

}
