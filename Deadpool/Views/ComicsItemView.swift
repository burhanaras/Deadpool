//
//  ComicsItemView.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI


struct ComicsItemView: View {
    
    let comics: Comics
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 24) {
                asyncImage
                    .frame(height: proxy.size.height * 0.75)
                    .background(Color.gray.opacity(0.6))
                    .clipped()
                
                VStack(alignment: .leading) {
                    Text(comics.title)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                    
                    Spacer(minLength: 12)
                    
                    HStack {
                        Text(comics.title)
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
        AsyncImage(url: comics.image) { phase in
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
    ComicsItemView(comics: DummyData.comics(count: 1)[0])
        .frame(width: 275, height: 566)
}
