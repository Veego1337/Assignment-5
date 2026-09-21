import SwiftUI

struct CardThumbnail: View {
    var card: Card
    
    var body: some View {
        ZStack {
            card.backgroundColor
            
            ForEach(card.elements.indices, id: \.self) { index in
                if let imageElement = card.elements[index] as? ImageElement, let uiImage = imageElement.uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageElement.transform.size.width * 0.15,
                               height: imageElement.transform.size.height * 0.15)
                }
            }
        }
        .cornerRadius(10)
        // Fixed color inference by explicitly using Color.gray
        .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 0)
    }
}
