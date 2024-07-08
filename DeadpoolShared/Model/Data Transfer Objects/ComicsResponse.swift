//
//  ComicsResponse.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation

struct ComicsResponse: Codable {
    let code: Int
    let data: ComicsData
}

struct ComicsData: Codable{
    let offset: Int
    let limit: Int
    let total: Int  //The total number of resources available given the current filter set.
    let results: [ComicDTO]
}

struct ComicDTO: Codable{
    let id: Int
    let title: String
    let thumbnail: ThumbnailDTO
}
