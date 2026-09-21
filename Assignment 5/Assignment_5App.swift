//
//  Assignment_5App.swift
//  Assignment 5
//
//  Created by Luca on 9/20/26.
//

import SwiftUI

@main
struct Assignment_5App: App {
    @StateObject var store = CardStore(defaultData: false)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
