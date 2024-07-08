//
//  Coordinator.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/7/24.
//

import Foundation

final class Coordinator{
    
    public static let shared = Coordinator()
    
    public var networkLayer: INetworkLayer = NetworkLayer()
    
    func marvelList() -> MarvelListScreen {
        let viewModel = MarvelListViewModel(networkLayer: networkLayer)
        return MarvelListScreen(viewModel: viewModel)
    }
    
    func navigateToDetail(marvel: Marvel) -> MarvelDetailScreen {
        let viewModel = MarvelDetailViewModel(networkLayer: NetworkLayer(), marvel: marvel)
        return MarvelDetailScreen(viewModel: viewModel)
    }
}
