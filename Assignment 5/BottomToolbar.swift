import SwiftUI

struct BottomToolbar: View {
    @Binding var card: Card
    @Binding var activeSheet: ActiveSheet?
    @EnvironmentObject var store: CardStore
    
    var body: some View {
        HStack(spacing: 0) {
            // Photos Button (Triggers PhotoModal sheet)
            Button(action: {
                activeSheet = .photoPicker
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    Text("Photos")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            
            // Frames Button (Triggers ShapePicker modal; disabled if no image element is selected)[cite: 1]
            Button(action: {
                activeSheet = .shapePicker
            }) {
                VStack(spacing: 4) {
                    Image(systemName: "square.on.square")
                        .font(.system(size: 20))
                    Text("Frames")
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
            }
            .disabled(store.selectedElement == nil || !(store.selectedElement is ImageElement))
        }
        .background(Color(.systemBackground).shadow(radius: 2))
    }
}
