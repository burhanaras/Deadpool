//
//  MarvelListViewModel.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import Foundation
import Combine

class MarvelListViewModel: ObservableObject{
    @Published private(set) var data: Result<[Marvel], CommonError>? = .none
    @Published private(set) var isPagingAvailable = false
    
    private var networkLayer: INetworkLayer
    private var cancellables: Set<AnyCancellable> = []
    
    private var currentPage = 0
    private var pageLimit = 30
    private var currentData = [Marvel]()
    
    init(networkLayer: INetworkLayer = NetworkLayer()) {
        self.networkLayer = networkLayer
        loadInitialPage()
    }
    
    func loadInitialPage(){
        self.currentPage = 0
        self.currentData = [Marvel]()
        self.subscribe(start: 0, number: pageLimit)
    }
    
    func loadNextPage() {
        guard isPagingAvailable else { return }
        self.subscribe(start: self.currentPage * self.pageLimit, number: self.pageLimit)
    }
}

// MARK: - Private methods

private extension MarvelListViewModel {
    func subscribe(start: Int, number: Int) {
        networkLayer.getCharacters(start: start, number: number)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion{
                case let .failure(error) where error == .malformedUrlError:
                    self?.data = .failure(.configurationError)
                case .finished:
                    break
                default:
                    self?.data = .failure(.networkError)
                }
            }, receiveValue: { [weak self] productsResponse in
                self?.currentData += productsResponse.data.results.map{Marvel.fromDTO(dto: $0)}
                if let currentData = self?.currentData{
                    self?.data = .success(self?.currentData ?? [])
                    self?.currentPage += 1
                    self?.isPagingAvailable = currentData.count < productsResponse.data.total
                }
            })
            .store(in: &cancellables)
    }
}
