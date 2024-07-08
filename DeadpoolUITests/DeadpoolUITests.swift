//
//  DeadpoolUITests.swift
//  DeadpoolUITests
//
//  Created by Burhan Aras on 7/6/24.
//
import XCTest

final class DeadpoolUITests: XCTestCase {
    
    let uiTestingLabel = "UITesting"
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // GIVEN: the application is in a state to be launched
            // WHEN: the application is launched
            // THEN: measure how long it takes to launch
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func test_shows_marvel_carousel_title() {
        // GIVEN: the app is set up for UI testing and launched
        let app = XCUIApplication()
        app.launchArguments.append(uiTestingLabel)
        app.launch()
        
        // WHEN: the Marvel Characters screen is loaded
        let title = app.staticTexts["Marvel Characters"]
        
        // THEN: the title should be visible
        XCTAssertTrue(title.exists)
    }
    
    func test_launches_successfully() {
        // GIVEN: the app is set up for UI testing and launched
        let app = XCUIApplication()
        app.launchArguments.append(uiTestingLabel)
        app.launch()
        
        // THEN: the app should be running
        XCTAssertTrue(app.exists)
        
        // WHEN: navigating through the carousel
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        let pageSize = 30
        let data = DummyDataGenerator.generateCharactersResponse(start: 0, number: pageSize)
        let title = data.data.results[0].name
        let description = data.data.results[0].description
        let expected = title + ", " + description
        
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        
        // THEN: the first character's name and description should be present
        XCTAssert(elementsQuery.buttons[expected].exists)
    }
    
    func test_first_page_loads_successfully() {
        // GIVEN: the app is set up for UI testing and launched
        let app = XCUIApplication()
        app.launchArguments.append(uiTestingLabel)
        app.launch()
        
        // THEN: the app should be running
        XCTAssertTrue(app.exists)
        
        // WHEN: navigating to the end of the first page
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        let pageSize = 30
        (0..<(pageSize - 1)).forEach { _ in
            XCUIRemote.shared.press(.right)
        }
        
        let data = DummyDataGenerator.generateCharactersResponse(start: 0, number: pageSize)
        let item = data.data.results[pageSize - 1]
        let expected = item.name + ", " + item.description
        let elementsQuery = XCUIApplication().scrollViews.otherElements
        
        // THEN: the last character on the first page should be present
        XCTAssert(elementsQuery.buttons[expected].exists)
    }
    
    func test_paging_works_successfully() {
        // GIVEN: the app is set up for UI testing and launched
        let app = XCUIApplication()
        app.launchArguments.append(uiTestingLabel)
        app.launch()
        
        // THEN: the app should be running
        XCTAssertTrue(app.exists)
        
        // WHEN: navigating to the second page
        XCUIRemote.shared.press(.down)
        XCUIRemote.shared.press(.left)
        
        let pageSize = 30
        (0...(pageSize + 1)).forEach { _ in
            XCUIRemote.shared.press(.right)
        }
        
        let data = DummyDataGenerator.generateCharactersResponse(start: 30, number: pageSize)
        
        // THEN: the first character on the second page should be present
        if let item = data.data.results.first {
            let expected = item.name + ", " + item.description
            let elementsQuery = XCUIApplication().scrollViews.otherElements
            XCTAssert(elementsQuery.buttons[expected].exists)
        } else {
            XCTFail("Response data is empty")
        }
    }
    
    func test_marvel_detail_loads_successfully() {
        // GIVEN: the app is set up for UI testing and launched
        let app = XCUIApplication()
        app.launchArguments.append(uiTestingLabel)
        app.launch()
        
        // THEN: the app should be running
        XCTAssertTrue(app.exists)
        
        // WHEN: navigating to the first character's detail screen
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
        
        // THEN: the detail screen should show the character's name
        XCTAssert(elementsQuery.staticTexts[title].exists)
        
        // AND: navigating around in the detail screen should work correctly
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
