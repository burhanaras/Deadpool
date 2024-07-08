//
//  MarvelListScreen.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI

struct MarvelListScreen: View {
    
    @ObservedObject var viewModel: MarvelListViewModel
        
    init(viewModel: MarvelListViewModel = MarvelListViewModel()) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    var body: some View {
        NavigationView{
            switch viewModel.data{
            case let .success(marvels): MarvelList(viewModel: viewModel, marvels: marvels)
            case let .failure(error):
                Text("\(error.localizedDescription)")
            case .none:
               ProgressView()
            }
        }
    }
}


struct MarvelList: View {

    @ObservedObject var viewModel: MarvelListViewModel
    let marvels: [Marvel]
        
    var body: some View{
        MarvelCarouselView(viewModel: viewModel, title: "Marvel Characters", marvels: marvels)
    }
}

#Preview("Successful") {
    MarvelListScreen(viewModel: MarvelListViewModel(networkLayer: DummyNetworkLayer()))
}

#Preview("Failing: Network error") {
    MarvelListScreen(viewModel: MarvelListViewModel(networkLayer: DummyFailingNetworkLayer()))
}

#Preview("Failing: Malformed URL") {
    MarvelListScreen(viewModel: MarvelListViewModel(networkLayer: DummyFailingMalformedUrlNetworkLayer()))
}
