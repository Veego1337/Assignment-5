//
//  UIImagesExtension.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI

extension UIImage {
    static var error: UIImage {
        return UIImage(systemName: "exclamationmark.triangle") ?? UIImage()
    }
    
    static func load(uuidString: String) -> UIImage {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return .error }
        let url = docs.appendingPathComponent(uuidString)
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) { return image }
        return .error
    }
    
    func save() -> String {
        let uuid = UUID().uuidString
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return uuid }
        let url = docs.appendingPathComponent(uuid)
        if let data = self.pngData() { try? data.write(to: url) }
        return uuid
    }
    
    static func remove(name: String?) {
        guard let name = name,
              let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let url = docs.appendingPathComponent(name)
        try? FileManager.default.removeItem(at: url)
    }
}
