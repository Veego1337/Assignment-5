//
//  ContentView.swift
//  Assignment 5
//
//  Created by Luca on 9/20/26.
//

//
//  ContentView.swift
//  Assignment 5
//
//  Created by Luca on 9/20/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        AppLoadingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(CardStore(defaultData: true))
    }
}
