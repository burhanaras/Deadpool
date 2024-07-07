//
//  MarvelDetailViewModelTests.swift
//  DeadpoolTests
//
//  Created by Burhan Aras on 7/7/24.
//

import XCTest
import Combine
@testable import Deadpool

final class MarvelDetailViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - MarvelDetail Tests
    func test_MarvelDetailViewModel_returns_correct_data() throws {
        // GIVEN: that we have a MarvelDTO and a NetworkLayer that returns that DTO for detail
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse, comicsResponse: testComicsResponse)
        
        // WHEN: MarvelDetailViewModel's loadProductDetail() is called
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        viewModel.loadMarvelDetail()
        
        // THEN: ViewModel's data should be same
        XCTAssertEqual(try viewModel.data?.get().id, String(testMarvelDTO0.id))
        XCTAssertEqual(try viewModel.data?.get().title, testMarvelDTO0.name)
        XCTAssertEqual(try viewModel.data?.get().description, testMarvelDTO0.description)
        XCTAssertEqual(try viewModel.data?.get().image, testMarvelDTO0.thumbnail.completeURL)
        
    }
    
    
    func test_MarvelDetailViewModel_loadComics_success() throws {
        // GIVEN: that we have a NetworkLayer that returns comicsResponse
        let networkLayer = MockNetworkLayer(comicsResponse: testComicsResponse)
        
        // WHEN: MarvelDetailViewModel's loadMarvelDetail() is called
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        viewModel.loadMarvelDetail()
        
        // THEN: ViewModel's comics should be same as the response
        XCTAssertEqual(viewModel.comics.count, testComicsResponse.data.results.count)
        XCTAssertEqual(viewModel.comics.first?.id, testComicsDTO0.id)
        XCTAssertEqual(viewModel.comics.first?.title, testComicsDTO0.title)
    }
    
    func test_MarvelDetailViewModel_loadComics_networkError() throws {
        // GIVEN: that we have a NetworkLayer that returns a network error
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse, shouldReturnError: true)
        
        // WHEN: MarvelDetailViewModel's loadMarvelDetail() is called
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        viewModel.loadMarvelDetail()
        
        // THEN: ViewModel's comics should be empty
        viewModel.$comics
            .sink { comics in
                XCTAssertTrue(comics.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    func test_MarvelDetailViewModel_loadComics_malformedUrlError() throws {
        // GIVEN: that we have a NetworkLayer that returns a malformed URL error
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse, shouldReturnConfigurationError: true)
        
        // WHEN: MarvelDetailViewModel's loadMarvelDetail() is called
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        viewModel.loadMarvelDetail()
        
        // THEN: ViewModel's comics should be empty
        viewModel.$comics
            .sink { comics in
                XCTAssertTrue(comics.isEmpty)
            }
            .store(in: &cancellables)
    }
    
    func test_MarvelDetailViewModel_isComicsLoading() throws {
        // GIVEN: A NetworkLayer that returns comicsResponse, viewModel.isComicsLoading is false initially
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse, comicsResponse: testComicsResponse, responseDelay: 2.0)
        let viewModel = MarvelDetailViewModel(networkLayer: networkLayer, marvel: Marvel.fromDTO(dto: testMarvelDTO0))
        XCTAssertFalse(viewModel.isComicsLoading)
        
        // WHEN: MarvelDetailViewModel's loadMarvelDetail() is called
        viewModel.loadMarvelDetail()
        
        // THEN: isComicsLoading should be true initially
        XCTAssertTrue(viewModel.isComicsLoading)
        
        let expectation = XCTestExpectation(description: "Wait for comics loading to finish")
        
        // Delayed assertion after some time
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            // Assert that isComicsLoading is now false
            XCTAssertFalse(viewModel.isComicsLoading)
            
            // Fulfill the expectation
            expectation.fulfill()
        }
        
        // Wait for expectation to fulfill
        wait(for: [expectation], timeout: 3)
    }

}
