//
//  DummyNetworkLayer.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation
import Combine


// MARK: - Network Layer To Return Dummy Data
class DummyNetworkLayer: INetworkLayer {
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.success(dummyCharactersResponse))
            .eraseToAnyPublisher()
    }
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.success(dummyComicsResponse))
            .eraseToAnyPublisher()
    }
}

// MARK: - Network Layer To Fail
class DummyFailingNetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.failure(.networkError))
            .eraseToAnyPublisher()
    }
}

class DummyFailingMalformedUrlNetworkLayer: INetworkLayer{
    var baseURL: NSString { return "https://gateway.marvel.com:443/v1/public" as NSString }
    
    func getCharacters(start: Int, number: Int) -> AnyPublisher<CharactersResponse, RequestError> {
        return Result<CharactersResponse, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
    
    func getComicsOf(characterId: String) -> AnyPublisher<ComicsResponse, RequestError> {
        return Result<ComicsResponse, RequestError>
            .Publisher(.failure(.malformedUrlError))
            .eraseToAnyPublisher()
    }
}
