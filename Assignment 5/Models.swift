//
//  Models.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI

struct Transform: Codable {
    var size: CGSize = CGSize(width: 250, height: 180)
    var rotation: Angle = .zero
    var offset: CGSize = .zero
}

protocol CardElement {
    var id: UUID { get }
    var transform: Transform { get set }
}

struct ImageElement: CardElement, Identifiable, Codable {
    let id = UUID()
    var transform = Transform()
    var uiImage: UIImage?
    var imageFilename: String?
    var frameIndex: Int?

    enum CodingKeys: CodingKey {
        case transform, imageFilename, frameIndex
    }

    init(uiImage: UIImage?, imageFilename: String?, frameIndex: Int? = nil) {
        self.uiImage = uiImage
        self.imageFilename = imageFilename
        self.frameIndex = frameIndex
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        transform = try container.decode(Transform.self, forKey: .transform)
        frameIndex = try container.decodeIfPresent(Int.self, forKey: .frameIndex)
        imageFilename = try container.decodeIfPresent(String.self, forKey: .imageFilename)
        if let imageFilename = imageFilename {
            uiImage = UIImage.load(uuidString: imageFilename)
        } else {
            uiImage = UIImage.error
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transform, forKey: .transform)
        try container.encode(frameIndex, forKey: .frameIndex)
        try container.encode(imageFilename, forKey: .imageFilename)
    }
}

struct TextElement: CardElement, Identifiable, Codable {
    let id = UUID()
    var transform = Transform()
    var text: String
}

struct ColorData: Codable {
    var r: Double, g: Double, b: Double, a: Double
}

struct Card: Identifiable, Codable {
    var id: UUID // Declared without an inline default value to satisfy Codable warning
    var backgroundColor: Color = .white
    var elements: [CardElement] = []
    
    enum CodingKeys: CodingKey {
        case id, backgroundColor, imageElements, textElements
    }

    init(backgroundColor: Color = .white) {
        self.id = UUID() // Explicitly initialized here
        self.backgroundColor = backgroundColor
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        self.id = UUID(uuidString: idString) ?? UUID()
        
        if let colorData = try? container.decode(ColorData.self, forKey: .backgroundColor) {
            self.backgroundColor = Color(red: colorData.r, green: colorData.g, blue: colorData.b, opacity: colorData.a)
        } else {
            self.backgroundColor = .white
        }
        
        if let imageElements = try? container.decode([ImageElement].self, forKey: .imageElements) {
            elements += imageElements
        }
        if let textElements = try? container.decode([TextElement].self, forKey: .textElements) {
            elements += textElements
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        
        let imageElements: [ImageElement] = elements.compactMap { $0 as? ImageElement }
        try container.encode(imageElements, forKey: .imageElements)
        
        let textElements: [TextElement] = elements.compactMap { $0 as? TextElement }
        try container.encode(textElements, forKey: .textElements)
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let colorData = ColorData(r: Double(r), g: Double(g), b: Double(b), a: Double(a))
        try container.encode(colorData, forKey: .backgroundColor)
    }
    
    mutating func addElement(uiImage: UIImage) {
        let filename = uiImage.save()
        let element = ImageElement(uiImage: uiImage, imageFilename: filename)
        elements.append(element)
        save()
    }
    
    // Supports matching calls with label 'text:'
    mutating func addElement(text element: TextElement) {
        elements.append(element)
        save()
    }
    
    mutating func remove(_ element: CardElement) {
        if let element = element as? ImageElement {
            UIImage.remove(name: element.imageFilename)
        }
        if let index = elements.firstIndex(where: { $0.id == element.id }) {
            elements.remove(at: index)
            save()
        }
    }
    
    mutating func update(_ element: CardElement?, frameIndex: Int) {
        if let imageElement = element as? ImageElement,
           let index = elements.firstIndex(where: { $0.id == imageElement.id }) {
            var updatedElement = imageElement
            updatedElement.frameIndex = frameIndex
            elements[index] = updatedElement
            save()
        }
    }
    
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            let filename = "\(id.uuidString).card"
            // iOS 14 compatible documents directory lookup
            guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let url = documentsURL.appendingPathComponent(filename)
            try data.write(to: url)
        } catch {
            print("Error saving card: \(error.localizedDescription)")
        }
    }
}

class CardStore: ObservableObject {
    @Published var cards: [Card] = []
    @Published var selectedElement: CardElement?
    
    init(defaultData: Bool = false) {
        if defaultData {
            cards = [Card(backgroundColor: .yellow)]
        } else {
            loadCards()
        }
    }
    
    func addCard() -> Card {
        let card = Card(backgroundColor: .white)
        cards.append(card)
        card.save()
        return card
    }
    
    private func loadCards() {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        if let enumerator = FileManager.default.enumerator(at: path, includingPropertiesForKeys: nil) {
            for case let fileURL as URL in enumerator where fileURL.pathExtension == "card" {
                if let data = try? Data(contentsOf: fileURL),
                   let card = try? JSONDecoder().decode(Card.self, from: data) {
                    cards.append(card)
                }
            }
        }
    }
}
