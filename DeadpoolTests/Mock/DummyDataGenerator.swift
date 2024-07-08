//
//  DummyDataGenerator.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/7/24.
//

import Foundation

// MARK: - Dummy test datas to use in test methods

final class DummyDataGenerator {
    
    static func generateThumbnailDTO() -> ThumbnailDTO {
        return ThumbnailDTO(path: "https://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", ext: "jpg")
    }
    
    static func generateMarvelDTO(id: Int) -> MarvelDTO {
        let thumbnail = generateThumbnailDTO()
        return MarvelDTO(id: id, name: "Marvel \(id)", description: "I'm Iron Man!", thumbnail: thumbnail)
    }
    
    static func generateMarvelDTOs(start: Int, count: Int) -> [MarvelDTO] {
        return (start..<start + count).map { generateMarvelDTO(id: $0) }
    }
    
    static func generateCharactersResponse(start: Int, number: Int) -> CharactersResponse {
        let characters = generateMarvelDTOs(start: start, count: number)
        let charactersData = CharactersDataResponse(offset: start, limit: number, total: 290, results: characters)
        return CharactersResponse(code: 200, data: charactersData)
    }
    
    static func generateComicDTO(id: Int) -> ComicDTO {
        let thumbnail = generateThumbnailDTO()
        return ComicDTO(id: id, title: "Comics \(id)", thumbnail: thumbnail)
    }
    
    static func generateComicsResponse() -> ComicsResponse {
        let comics = [generateComicDTO(id: 0)]
        let comicsData = ComicsData(offset: 0, limit: 10, total: 30, results: comics)
        return ComicsResponse(code: 200, data: comicsData)
    }
}
