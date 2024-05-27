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
    @Query private var items: [Item]
    @State private var isPresentingAddItemView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        EditItemView(item: item)
                            .navigationBarTitle("Edit Item", displayMode: .automatic)
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
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
        .modelContainer(for: Item.self, inMemory: true)
}
