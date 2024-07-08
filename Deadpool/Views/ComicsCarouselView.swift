//
//  ComicsCarouselView.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI

struct ComicsCarouselView: View {
    
    let title: String
    let comics: [Comics]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
                .padding(.horizontal, 64)
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 32) {
                    ForEach(comics) { comics in
                        NavigationLink {
                           Text("To be implemented")
                        } label: {
                            ComicsItemView(comics: comics)
                                .frame(width: 275, height: 566)
                                .buttonStyle(.card)
                        }
                        .buttonStyle(.card)
                    }
                }
                .padding([.bottom, .horizontal], 64)
                .padding(.top, 32)
            }
        }
    }
}

#Preview {
    ComicsCarouselView(title: "Comics", comics: DummyData.comics(count: 10))
}
