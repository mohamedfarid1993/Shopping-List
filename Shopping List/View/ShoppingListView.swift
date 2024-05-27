//
//  ShoppingListView.swift
//  Shopping List
//
//  Created by Mohamed Farid on 27/05/2024.
//

import SwiftUI
import SwiftData

struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Item> { !$0.isBought }) private var items: [Item]
    @State private var isPresentingAddItemView = false
    
    var body: some View {
        NavigationView {
            List {
                if items.isEmpty {
                    Text("Your shopping list is empty. Start adding items by tapping the '+' button.")
                        .foregroundColor(.secondary)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(alignment: .center)
                } else {
                    ForEach(items) { item in
                        NavigationLink {
                            EditItemView(item: item)
                                .navigationBarTitle("Edit Item", displayMode: .automatic)
                        } label: {
                            ShoppingItemView(item: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !items.isEmpty {
                        EditButton()
                    }
                }
                ToolbarItem {
                    Button(action: { isPresentingAddItemView.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingAddItemView) {
            AddItemView(isPresented: $isPresentingAddItemView)
                .environment(\.modelContext, modelContext)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
