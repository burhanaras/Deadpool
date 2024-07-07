//
//  MockNetworkLayer.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/7/24.
//

import Combine
import Foundation

class MockNetworkLayer: INetworkLayer {
    private var charactersResponse: CharactersResponse?
    private var comicsResponse: ComicsResponse?
    private var shouldReturnError: Bool
    private var shouldReturnConfigurationError: Bool
    
    init(charactersResponse: CharactersResponse? = nil,
         comicsResponse: ComicsResponse? = nil,
         shouldReturnError: Bool = false,
         shouldReturnConfigurationError: Bool = false) {
        self.charactersResponse = charactersResponse
        self.comicsResponse = comicsResponse
        self.shouldReturnError = shouldReturnError
        self.shouldReturnConfigurationError = shouldReturnConfigurationError
    }
    
    var baseURL: NSString { return "" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        if shouldReturnError {
            return Fail(error: RequestError.networkError).eraseToAnyPublisher()
        }
        if shouldReturnConfigurationError {
            return Fail(error: RequestError.malformedUrlError).eraseToAnyPublisher()
        }
        if let response = charactersResponse {
            return Just(response)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: RequestError.networkError).eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        if shouldReturnError {
            return Fail(error: RequestError.networkError).eraseToAnyPublisher()
        }
        if shouldReturnConfigurationError {
            return Fail(error: RequestError.malformedUrlError).eraseToAnyPublisher()
        }
        if let response = comicsResponse {
            return Just(response)
                .setFailureType(to: RequestError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: RequestError.networkError).eraseToAnyPublisher()
    }
}
