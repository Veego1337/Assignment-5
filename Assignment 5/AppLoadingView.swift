//
//  AppLoadingView.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI

struct AppLoadingView: View {
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation { showSplash = false }
                    }
                }
        } else {
            CardsListView()
        }
    }
}
