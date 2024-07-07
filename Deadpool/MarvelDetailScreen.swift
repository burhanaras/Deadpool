//
//  MarvelDetailScreen.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI

struct MarvelDetailScreen: View {
    @ObservedObject var viewModel: MarvelDetailViewModel
    
    var body: some View {
        VStack {
            switch viewModel.data{
            case let .success(marvel):
                MarvelDetail(viewModel: viewModel, hero: marvel)
            case let .failure(error):
                Text("\(error.localizedDescription)")
            case .none:
                ProgressView()
            }
        }
        .onAppear {
            viewModel.loadMarvelDetail()
        }
    }
}

struct MarvelDetail: View {
    
    @FocusState private var isButtonFocused: Bool
    
    @ObservedObject var viewModel: MarvelDetailViewModel
    let hero: Marvel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                HStack {
                    AsyncImage(url: hero.image) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                        } else if phase.error != nil {
                            Text("Failed to load image")
                        } else {
                            ProgressView()
                        }
                    }
                    .frame(width: 420, height: 420)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
                    .shadow(radius: 12)
                    
                    VStack (alignment: .leading) {
                        Text(hero.title).font(.title).padding()
                        Text(hero.description.isEmpty ? "This character doesn't have any description." : hero.description).font(.body).padding()

                        Button("Add To Favorites") {
                            // To be implemented
                        }
                        .focused($isButtonFocused)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer()

                if viewModel.isComicsLoading {
                    ProgressView()
                        .padding()
                } else{
                    ComicsCarouselView(title: "Comics of \(hero.title)", comics: viewModel.comics)
                        .padding(.bottom)
                }
                
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {  // Add a slight delay to ensure focus
                self.isButtonFocused = true
            }
        }
    }
}

#Preview("Success") {
    MarvelDetailScreen(viewModel: MarvelDetailViewModel(networkLayer: DummyNetworkLayer(), marvel: DummyData.marvel()))
}

#Preview("Failure") {
    MarvelDetailScreen(viewModel: MarvelDetailViewModel(networkLayer: DummyFailingNetworkLayer(), marvel: DummyData.marvel()))
}
