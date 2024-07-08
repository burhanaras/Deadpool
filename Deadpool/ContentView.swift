//
//  ContentView.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Coordinator.shared.marvelList()
                .edgesIgnoringSafeArea(.horizontal)
                .tabItem {
                    Label("Charcters", systemImage: "newspaper")
                }
                .tag("news")
            
            Text("To be developed")
                .tabItem {
                    Label("Comics", systemImage: "bookmark")
                }
                .tag("saved")
            
            Text("To be developed")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
                .tag("search")
        }
    }
}

#Preview {
    ContentView()
}
