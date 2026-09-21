//
//  PhotoModal.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//
//
//  PhotoModal.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI

struct PhotoModal: View {
    @Binding var card: Card
    
    var body: some View {
        // Safe on iOS 14 using UIKit's photo picker wrapper
        ImagePicker(card: $card)
            .edgesIgnoringSafeArea(.all)
    }
}
