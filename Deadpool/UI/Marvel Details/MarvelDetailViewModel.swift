//
//  MarvelDetailViewModel.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation
import Combine

class MarvelDetailViewModel: ObservableObject {
    @Published private(set) var data: Result<Marvel, CommonError>? = .none
    @Published private(set) var comics: [Comics] = [Comics]()
    @Published private(set) var isComicsLoading: Bool = false
    
    private var networkLayer: INetworkLayer
    private var marvel: Marvel
    
    init(networkLayer: INetworkLayer, marvel: Marvel) {
        self.networkLayer = networkLayer
        self.marvel = marvel
        self.data = .success(marvel)
    }
    
    @MainActor
    func loadMarvelDetail() async {
        await loadComics(characterId: marvel.id)
    }
    
    @MainActor
    private func loadComics(characterId: String) async {
        self.isComicsLoading = true
        do {
            let comicsResponse = try await networkLayer.getComicsOf(characterId: characterId).async()
            self.comics = comicsResponse.data.results.map { Comics.fromDTO(dto: $0) }
            self.isComicsLoading = false
        } catch {
            self.comics = []
            self.isComicsLoading = false
        }
    }
}

extension AnyPublisher {
    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = self.sink { completion in
                if case let .failure(error) = completion {
                    continuation.resume(throwing: error)
                }
                cancellable?.cancel()
            } receiveValue: { value in
                continuation.resume(returning: value)
            }
        }
    }
}
