//
//  DeadpoolApp.swift
//  Deadpool
//
//  Created by Burhan Aras on 7/6/24.
//

import SwiftUI

@main
struct DeadpoolApp: App {
    
    init() {
        #if DEBUG
        if CommandLine.arguments.contains("UITesting") {
            Coordinator.shared.networkLayer = MockNetworkLayer()
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(.black)
        }
    }
}
