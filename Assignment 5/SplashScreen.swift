//
//  SplashScreen.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).ignoresSafeArea()
            
            card(letter: "S", color: .blue).splashAnimation(finalYposition: 240, delay: 0)
            card(letter: "D", color: .green).splashAnimation(finalYposition: 120, delay: 0.2)
            card(letter: "R", color: .orange).splashAnimation(finalYposition: 0, delay: 0.4)
            card(letter: "A", color: .red).splashAnimation(finalYposition: -120, delay: 0.6)
            card(letter: "C", color: .purple).splashAnimation(finalYposition: -240, delay: 0.8)
        }
    }
    
    func card(letter: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25).fill(Color.white).shadow(radius: 3).frame(width: 120, height: 160)
            Text(letter).fontWeight(.bold).font(.system(size: 80)).foregroundColor(color).frame(width: 80)
        }
    }
}

private struct SplashAnimation: ViewModifier {
    @State private var animating = true
    let finalYPosition: CGFloat
    let delay: Double
    
    func body(content: Content) -> some View {
        content
            .offset(y: animating ? -700 : finalYPosition)
            .rotationEffect(animating ? .zero : Angle(degrees: Double.random(in: -10...10)))
            .animation(Animation.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(delay), value: animating)
            .onAppear { animating = false }
    }
}

private extension View {
    func splashAnimation(finalYposition: CGFloat, delay: Double) -> some View {
        modifier(SplashAnimation(finalYPosition: finalYposition, delay: delay))
    }
}
