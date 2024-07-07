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
    private var responseDelay: TimeInterval?
    
    init(charactersResponse: CharactersResponse? = nil,
         comicsResponse: ComicsResponse? = nil,
         shouldReturnError: Bool = false,
         shouldReturnConfigurationError: Bool = false,
         responseDelay: TimeInterval? = nil) {
        self.charactersResponse = charactersResponse
        self.comicsResponse = comicsResponse
        self.shouldReturnError = shouldReturnError
        self.shouldReturnConfigurationError = shouldReturnConfigurationError
        self.responseDelay = responseDelay
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
            if let delay = responseDelay, delay > 0 {
                return Future { promise in
                    DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                        promise(.success(response))
                    }
                }.eraseToAnyPublisher()
            } else {
                return Just(response)
                    .setFailureType(to: RequestError.self)
                    .eraseToAnyPublisher()
            }
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
            if let delay = responseDelay, delay > 0 {
                return Future { promise in
                    DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                        promise(.success(response))
                    }
                }.eraseToAnyPublisher()
            } else {
                return Just(response)
                    .setFailureType(to: RequestError.self)
                    .eraseToAnyPublisher()
            }
        }
        
        return Fail(error: RequestError.networkError).eraseToAnyPublisher()
    }
}
