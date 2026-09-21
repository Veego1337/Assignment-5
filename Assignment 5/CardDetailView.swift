//
//  CardDetailView.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

//
//  CardDetailView.swift
//  Assignment 5
//
//  Created by Luca on 9/21/26.
//

import SwiftUI
import UniformTypeIdentifiers

enum ActiveSheet: Identifiable {
    case photoPicker, shapePicker
    var id: Self { self }
}

struct CardDetailView: View {
    @Binding var card: Card
    var viewScale: CGFloat = 1.0
    
    @EnvironmentObject var store: CardStore
    @State var activeSheet: ActiveSheet?
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                card.backgroundColor
                    .ignoresSafeArea()
                    .onTapGesture {
                        store.selectedElement = nil
                    }
                
                ForEach(card.elements.indices, id: \.self) { index in
                    CardDetailElementView(element: $card.elements[index], card: $card, viewScale: viewScale)
                        .environmentObject(store)
                }
            }
            // iOS 14 compatible drop handler for external images and text
            .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers in
                for provider in providers {
                    if provider.canLoadObject(ofClass: UIImage.self) {
                        provider.loadObject(ofClass: UIImage.self) { image, _ in
                            if let uiImage = image as? UIImage {
                                DispatchQueue.main.async {
                                    card.addElement(uiImage: uiImage)
                                    card.save()
                                }
                            }
                        }
                    } else if provider.hasItemConformingToTypeIdentifier("public.plain-text") {
                        provider.loadItem(forTypeIdentifier: "public.plain-text", options: nil) { (textData, _) in
                            if let text = textData as? String {
                                DispatchQueue.main.async {
                                    let newTextElement = TextElement(text: text)
                                    card.elements.append(newTextElement)
                                    card.save()
                                }
                            }
                        }
                    }
                }
                return true
            }
            
            // Bottom Toolbar Controls
            BottomToolbar(card: $card, activeSheet: $activeSheet)
                .environmentObject(store)
        }
        .onDisappear {
            store.selectedElement = nil
            card.save()
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .photoPicker:
                ImagePicker(card: $card)
            case .shapePicker:
                ShapePicker(card: $card)
                    .environmentObject(store)
            }
        }
    }
}

struct CardDetailElementView: View {
    @Binding var element: CardElement
    @Binding var card: Card
    var viewScale: CGFloat
    
    @EnvironmentObject var store: CardStore
    
    var body: some View {
        Group {
            if let imageElement = element as? ImageElement {
                ImageElementView(element: imageElement)
            } else if let textElement = element as? TextElement {
                Text(textElement.text)
                    .font(.largeTitle)
            }
        }
        .border(Settings.borderColor, width: isSelected ? Settings.borderWidth : 0)
        .elementContextMenu(card: $card, element: $element)
        .onTapGesture {
            store.selectedElement = element
        }
    }
    
    var isSelected: Bool {
        store.selectedElement?.id == element.id
    }
}

struct ImageElementView: View {
    var element: ImageElement
    
    var body: some View {
        Group {
            if let uiImage = element.uiImage {
                let baseImage = Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                if let frameIndex = element.frameIndex, frameIndex < Shapes.shapes.count {
                    baseImage
                        .clipShape(Shapes.shapes[frameIndex])
                        .contentShape(Shapes.shapes[frameIndex])
                } else {
                    baseImage
                }
            } else {
                Image(uiImage: UIImage.error)
            }
        }
        .frame(width: element.transform.size.width, height: element.transform.size.height)
    }
}

struct ShapePicker: View {
    @Binding var card: Card
    @EnvironmentObject var store: CardStore
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                    ForEach(0..<Shapes.shapes.count, id: \.self) { index in
                        Shapes.shapes[index]
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 90, height: 90)
                            .padding()
                            .onTapGesture {
                                card.update(store.selectedElement, frameIndex: index)
                                card.save()
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Frame")
        }
    }
}

extension View {
    func elementContextMenu(card: Binding<Card>, element: Binding<CardElement>) -> some View {
        self.contextMenu {
            Button(action: {
                card.wrappedValue.remove(element.wrappedValue)
            }) {
                Label("Delete", systemImage: "trash")
                    .foregroundColor(.red)
            }
        }
    }
}
