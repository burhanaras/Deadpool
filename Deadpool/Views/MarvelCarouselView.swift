//
//  MarvelCarouselView.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI

struct MarvelCarouselView: View {
    
    @ObservedObject var viewModel: MarvelListViewModel
    
    let title: String
    let marvels: [Marvel]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.horizontal, 64)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 32) {
                    ForEach(marvels) { marvel in
                        NavigationLink {
                            Coordinator.shared.navigateToDetail(marvel: marvel)
                        } label: {
                            MarvelItemView(marvel: marvel)
                                .frame(width: 420, height: 420)
                        }
                        .buttonStyle(.card)
                    }
                    
                    if viewModel.isPagingAvailable{
                        ProgressView()
                            .onAppear{
                                viewModel.loadNextPage()
                            }
                    }
                }
                .padding([.bottom, .horizontal], 64)
                .padding(.top, 32)
            }
        }
    }
}


#Preview {
    MarvelCarouselView(viewModel: MarvelListViewModel(), title: "Marvel Heroes", marvels: DummyData.marvels())
}
