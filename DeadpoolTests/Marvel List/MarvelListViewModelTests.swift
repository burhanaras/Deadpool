//
//  MarvelListViewModelTests.swift
//  DeadpoolTests
//
//  Created by Burhan Aras on 7/7/24.
//

@testable import Deadpool
import XCTest
import Combine

final class MarvelListViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable> = []
    
    func test_MarvelListViewModel_loadInitialPage() throws {
        // GIVEN: A network layer with a predefined characters response
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse)
        
        // WHEN: The MarvelListViewModel's loadInitialPage method is called
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        viewModel.loadInitialPage()
        
        // THEN: The ViewModel's data should be populated with the correct characters
        viewModel.$data
            .sink { result in
                if case .success(let data) = result {
                    XCTAssertEqual(data.count, testCharactersResponse.data.results.count)
                    XCTAssertEqual(data.first?.id, String(testCharactersResponse.data.results.first?.id ?? 0))
                } else {
                    XCTFail("Expected success but got \(String(describing: result))")
                }
            }
            .store(in: &cancellables)
    }
    
    func test_MarvelListViewModel_pagingAvailability() throws {
        // GIVEN: A network layer with a predefined characters response
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse)
        
        // WHEN: The MarvelListViewModel's loadInitialPage method is called
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        viewModel.loadInitialPage()
        
        // THEN: The ViewModel should correctly determine if paging is available
        viewModel.$isPagingAvailable
            .sink { isPagingAvailable in
                XCTAssertEqual(isPagingAvailable, testCharactersResponse.data.results.count < testCharactersResponse.data.total)
            }
            .store(in: &cancellables)
    }
    
    func test_MarvelListViewModel_loadNextPage() throws {
        // GIVEN: A network layer with a predefined characters response
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse)
        
        // WHEN: The MarvelListViewModel's loadInitialPage and loadNextPage methods are called
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        viewModel.loadInitialPage()
        viewModel.loadNextPage()
        
        // THEN: The ViewModel's data should contain the combined results of both pages
        viewModel.$data
            .sink { result in
                if case .success(let data) = result {
                    XCTAssertEqual(data.count, testCharactersResponse.data.results.count * 2)
                } else {
                    XCTFail("Expected success but got \(String(describing: result))")
                }
            }
            .store(in: &cancellables)
    }
    
    func test_MarvelListViewModel_networkError() throws {
        // GIVEN: A network layer that returns a network error
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse, shouldReturnError: true)
        
        // WHEN: The MarvelListViewModel's loadInitialPage method is called
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        viewModel.loadInitialPage()
        
        // THEN: The ViewModel's data should contain a network error
        viewModel.$data
            .sink { result in
                if case .failure(let error) = result {
                    XCTAssertEqual(error, .networkError)
                } else {
                    XCTFail("Expected failure but got \(String(describing: result))")
                }
            }
            .store(in: &cancellables)
    }
    
    func test_MarvelListViewModel_malformedUrlError() throws {
        // GIVEN: A network layer that returns a malformed URL error
        let networkLayer = MockNetworkLayer(charactersResponse: testCharactersResponse, shouldReturnConfigurationError: true)
        
        // WHEN: The MarvelListViewModel's loadInitialPage method is called
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        viewModel.loadInitialPage()
        
        // THEN: The ViewModel's data should contain a configuration error
        viewModel.$data
            .sink { result in
                if case .failure(let error) = result {
                    XCTAssertEqual(error, .configurationError)
                } else {
                    XCTFail("Expected failure but got \(String(describing: result))")
                }
            }
            .store(in: &cancellables)
    }
}
