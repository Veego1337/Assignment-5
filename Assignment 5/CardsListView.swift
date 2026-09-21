import SwiftUI

struct CardsListView: View {
    @EnvironmentObject var store: CardStore
    @State private var selectedCard: Card?
    
    private let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        VStack {
            if store.cards.isEmpty {
                initialView
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(store.cards) { card in
                            CardThumbnail(card: card)
                                .onTapGesture { selectedCard = card }
                        }
                    }
                    .padding(20)
                }
            }
            
            Button {
                selectedCard = store.addCard()
            } label: {
                Label("Create New", systemImage: "plus")
                    .frame(maxWidth: .infinity)
                    .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .fullScreenCover(item: $selectedCard) { card in
            NavigationView {
                CardDetailView(card: binding(for: card))
                    .navigationBarItems(trailing: Button("Done") { selectedCard = nil })
            }
            .environmentObject(store)
        }
    }
    
    private func binding(for card: Card) -> Binding<Card> {
        Binding<Card>(
            get: { card },
            set: { updatedCard in
                if let index = store.cards.firstIndex(where: { $0.id == updatedCard.id }) {
                    store.cards[index] = updatedCard
                }
            }
        )
    }
    
    var initialView: some View {
        let tempCard = Card(backgroundColor: Color(UIColor.systemBackground))
        return VStack {
            Spacer()
            ZStack {
                CardThumbnail(card: tempCard)
                Image(systemName: "plus.circle.fill").font(.largeTitle).foregroundColor(.gray)
            }
            .frame(width: 150, height: 200)
            .onTapGesture { selectedCard = store.addCard() }
            
            Text("Tap the plus button to add a card")
                .padding(.top).foregroundColor(.gray)
            Spacer()
        }
    }
}
