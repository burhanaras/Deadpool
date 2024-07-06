//
//  Marvel.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation

struct Marvel: Identifiable, Equatable{
    let id: String
    let title: String
    let image: URL
    let description: String
}

extension Marvel{
    static func fromDTO(dto: MarvelDTO) -> Marvel{
        let marvel =  Marvel(
            id: "\(dto.id)",
            title: dto.name,
            image: dto.thumbnail.completeURL ?? URL(string: "")!,
            description: dto.description
        )
        return marvel
    }
}
