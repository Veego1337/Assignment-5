//
//  Shapes.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI

// iOS 14 Compatible AnyShape Wrapper to preserve Shape conformance and .fill() support
struct AnyShape: Shape {
    private let pathClosure: (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        self.pathClosure = { rect in shape.path(in: rect) }
    }
    
    func path(in rect: CGRect) -> Path {
        pathClosure(rect)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        let width = rect.width, height = rect.height
        var path = Path()
        path.addLines([
            CGPoint(x: width * 0.13, y: height * 0.2),
            CGPoint(x: width * 0.87, y: height * 0.47),
            CGPoint(x: width * 0.4, y: height * 0.93)
        ])
        path.closeSubpath()
        return path
    }
}

struct Cone: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let radius = min(rect.midX, rect.midY)
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 180), clockwise: true)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
        path.addLine(to: CGPoint(x: rect.midX + radius, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

struct Lens: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.width, y: rect.midY), control: CGPoint(x: rect.midX, y: 0))
        path.addQuadCurve(to: CGPoint(x: 0, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.height))
        path.closeSubpath()
        return path
    }
}

enum Shapes {
    static let shapes: [AnyShape] = [
        AnyShape(Circle()),
        AnyShape(Rectangle()),
        AnyShape(Triangle()),
        AnyShape(Cone()),
        AnyShape(Lens())
    ]
}
