//
//  MarvelItemView.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI


struct MarvelItemView: View {
    
    let marvel: Marvel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 24) {
                asyncImage
                    .frame(height: proxy.size.height * 0.6)
                    .background(Color.gray.opacity(0.6))
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text(marvel.title)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    Spacer(minLength: 12)
                    
                    HStack {
                        Text(marvel.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
                    }
                }
                .padding([.horizontal, .bottom])
            }
        }
    }
    
    private var asyncImage: some View  {
        AsyncImage(url: marvel.image) { phase in
            switch phase {
            case .empty:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            case .failure:
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .imageScale(.large)
                    Spacer()
                }
                
                
            @unknown default:
                fatalError()
            }
        }
    }
}

#Preview {
    MarvelItemView(marvel: DummyData.marvel())
        .frame(width: 400, height: 400)
}
