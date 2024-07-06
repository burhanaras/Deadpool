//
//  Comics.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation

struct Comics: Identifiable {
    let id: Int
    let title: String
    let image: URL
}

extension Comics{
    static func fromDTO(dto: ComicDTO) -> Comics {
        return Comics(id: dto.id, title: dto.title, image: dto.thumbnail.completeURL ?? URL(string: "")!)
    }
}
